namespace Vaipe {
    public class CommandEntry : Gtk.Entry {
        private CommandResolver commands;
        private weak Gtk.Widget? previous_focus;

        private CompletionPopover? completion_menu;
        private string? completion_text;
        private CompletionContext? completion_context;
        private uint focus_check;

        private string current_command {
            owned get {
                int end = text.index_of (" ");
                return text.substring (0, end < 0 ? text.length : end);
            }
        }

        private bool can_complete_command {
            get {
                // You can complete a command when the cursor is at the end of the command name and there is no selection.
                int selection_start, selection_end;
                return get_position () == current_command.char_count () &&
                       !get_selection_bounds (out selection_start, out selection_end);
            }
        }

        public CommandEntry (CommandResolver commands) {
            Object (placeholder_text : _("Enter a command"),
                    halign : Gtk.Align.FILL,
                    valign : Gtk.Align.END,
                    hexpand: true,
                    visible: false);
            this.commands = commands;

            update_property (Gtk.AccessibleProperty.LABEL, _("Command"));

            completion_menu = new CompletionPopover (this);
            completion_menu.candidate_selected.connect (insert_completion);
            completion_menu.closed.connect (check_focus_later);

            changed.connect (reset_completion);
            notify["cursor-position"].connect (reset_completion);
            notify["selection-bound"].connect (reset_completion);

            // Close the command entry when focus is lost
            var focus_controller = new Gtk.EventControllerFocus ();
            focus_controller.leave.connect (check_focus_later);
            add_controller (focus_controller);

            // Close the command entry when escape is pressed
            var key_controller = new Gtk.EventControllerKey ();
            key_controller.propagation_phase = Gtk.PropagationPhase.CAPTURE;
            key_controller.key_pressed.connect (handle_key_pressed);
            add_controller (key_controller);
        }

        protected override void dispose () {
            completion_menu = null;
            if (focus_check != 0) {
                Source.remove (focus_check);
                focus_check = 0;
            }

            base.dispose ();
        }

        public void show_command_entry () {
            if (visible)return;

            // Save current focus
            previous_focus = root == null ? null : root.get_focus ();

            visible = true;
            grab_focus ();
        }

        public void hide_command_entry (bool restore_focus = true) {
            if (!visible)return;

            visible = false;
            text = "";
            reset_completion ();

            // Restore previous focus
            if (restore_focus && previous_focus != null) {
                previous_focus.grab_focus ();
            }
            previous_focus = null;
        }

        public override void activate () {
            // Separate the command name from its argument string
            string[] argv = text.split (" ", 2);

            if (argv.length == 0) {
                // Empty command
                hide_command_entry ();
                return;
            }

            // Resolve command by name
            Command? command = commands.lookup (argv[0]);
            if (command == null) {
                Window.message (this, _("Command not found"));
                return;
            }

            try {
                string? remaining = argv.length > 1 && argv[1].length > 0 ? argv[1] : null;
                if (!command.activate (previous_focus, remaining)) {
                    Window.message (this, _("Command unavailable in this context"));
                    return;
                }
            } catch (CommandError e) {
                Window.message (this, e.message);
                return;
            }

            // Command was successfully executed
            hide_command_entry (true);
        }

        // Check if the command entry has lost focus, and hide it if so.
        private void check_focus_later () {
            if (focus_check != 0)return;

            // Let GTK finish moving focus between the entry and its popover.
            focus_check = Idle.add (() => {
                focus_check = 0;
                var focus = root == null ? null : root.get_focus ();
                // If the command entry is visible and focus has moved outside of it, hide it.
                if (visible && (focus == null || (focus != this && !focus.is_ancestor (this)))) {
                    hide_command_entry (false);
                }
                return Source.REMOVE;
            });
        }

        private void reset_completion () {
            completion_text = null;
        }

        // Choose a model and replacement range for the cursor's current context.
        private CompletionContext ? create_completion_context () {
            if (!can_complete_command)return null;

            string word = current_command;
            return new CompletionContext (new CommandNameCompletionModel (commands), 0, word.char_count (), word);
        }

        private void insert_completion (string name) {
            if (completion_context != null)completion_context.replace (this, name, true);
        }

        private void complete_command () {
            if (completion_context == null || completion_text != text) {
                completion_context = create_completion_context ();
            }
            if (completion_context == null) {
                // No completion context available, or the cursor is not at the end of the command name.
                reset_completion ();
                error_bell ();
                return;
            }

            var model = completion_context.model;
            int items = model.get_n_items ();
            if (items == 0) {
                // No completion candidates to show.
                reset_completion ();
                error_bell ();
                return;
            } else if (items == 1) {
                // One unambiguous completion candidate; insert it immediately.
                insert_completion (model.get_completion (0));
                return;
            }

            // Multiple completion candidates; show the popover menu.
            if (completion_text == text) {
                completion_menu.model = model;
                completion_menu.show_candidates ();
                return;
            }

            // Insert the common prefix, keeping the same context for the next Tab.
            string common = model.common_prefix;
            completion_context.replace (this, common);
            completion_context.refilter (common, get_position ());
            completion_text = text;
            error_bell (); // Since completion is still ambiguous
        }

        private bool handle_key_pressed (Gtk.EventControllerKey c, uint keyval, uint keycode, Gdk.ModifierType mods) {
            if (completion_menu.visible)return false;

            switch (keyval) {
            case Gdk.Key.Escape :
                hide_command_entry ();
                return true; // Handled

            case Gdk.Key.Tab :
                // All but capslock must not be pressed.
                if ((mods & (Gdk.ModifierType.SHIFT_MASK | Gdk.ModifierType.CONTROL_MASK
                             | Gdk.ModifierType.ALT_MASK | Gdk.ModifierType.SUPER_MASK)) == 0) {
                    complete_command ();
                    return true;
                }
                break;
            }

            return false; // Not handled by this widget
        }
    }
}