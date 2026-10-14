namespace Vaipe {
    public class CommandEntry : Gtk.Entry {
        private CommandResolver commands;
        private weak Gtk.Widget? previous_focus;

        public CommandEntry (CommandResolver commands) {
            Object (placeholder_text : _("Enter a command"),
                    halign: Gtk.Align.FILL,
                    valign: Gtk.Align.END,
                    hexpand: true,
                    visible: false);
            this.commands = commands;

            update_property (Gtk.AccessibleProperty.LABEL, _("Command"));

            // Close the command entry when focus is lost
            var focus_controller = new Gtk.EventControllerFocus ();
            focus_controller.leave.connect (() => hide_command_entry (false)); // Don't restore old focus
            add_controller (focus_controller);

            // Close the command entry when escape is pressed
            var key_controller = new Gtk.EventControllerKey ();
            key_controller.propagation_phase = Gtk.PropagationPhase.CAPTURE;
            key_controller.key_pressed.connect (on_key_pressed);
            add_controller (key_controller);
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
            // Restore previous focus
            if (restore_focus && previous_focus != null) {
                previous_focus.grab_focus ();
            }
            previous_focus = null;
        }

        private bool on_key_pressed (Gtk.EventControllerKey c, uint keyval, uint keycode, Gdk.ModifierType mods) {
            if (keyval == Gdk.Key.Escape) {
                hide_command_entry ();
                return true; // Handled
            }

            return false; // Not handled by this widget
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
                if (!command.activate (previous_focus, argv[1])) {
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
    }
}