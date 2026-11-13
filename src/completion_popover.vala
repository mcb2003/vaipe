namespace Vaipe {
    // The UI for tab completion.
    public class CompletionPopover : Object {
        private Gtk.PopoverMenu widget;
        private weak Gtk.Entry? entry;
        private Gtk.EventControllerKey key_controller;

        public bool visible { get { return widget.visible; } }

        public signal void candidate_selected (string candidate);
        public signal void closed ();

        public CompletionPopover (Gtk.Entry entry) {
            this.entry = entry;
            widget = new Gtk.PopoverMenu.from_model (null) {
                position = Gtk.PositionType.TOP
            };

            var actions = new SimpleActionGroup ();
            var select = new SimpleAction ("select", VariantType.STRING);
            select.activate.connect ((parameter) => {
                dismiss (true);
                candidate_selected (parameter.get_string ());
            });
            actions.add_action (select);
            widget.insert_action_group ("completion", actions);

            widget.set_parent (entry);
            widget.closed.connect (() => closed ());

            // Dismiss the popover when the entry changes or loses focus.
            entry.changed.connect (on_entry_changed);
            entry.notify["cursor-position"].connect (on_entry_changed);
            entry.notify["selection-bound"].connect (on_entry_changed);
            entry.notify["visible"].connect (on_entry_visibility_changed);

            key_controller = new Gtk.EventControllerKey ();
            key_controller.propagation_phase = Gtk.PropagationPhase.CAPTURE;
            key_controller.key_pressed.connect (handle_key_pressed);
            entry.add_controller (key_controller);
        }

        protected override void dispose () {
            if (entry != null) {
                entry.remove_controller (key_controller);
                entry = null;
            }
            if (widget.get_parent () != null) {
                // Must do this because we used set_parent.
                widget.unparent ();
            }

            base.dispose ();
        }

        public void dismiss (bool restore_focus = false) {
            if (!visible)return;
            int cursor = entry == null ? 0 : entry.get_position ();
            widget.popdown ();
            if (restore_focus && entry != null) {
                entry.grab_focus_without_selecting ();
                entry.set_position (cursor);
            }
        }

        public void show_candidates (string[] candidates) {
            // Close the menu when there are no candidates.
            if (entry == null || candidates.length == 0) {
                dismiss ();
                return;
            }

            // Fill a GMenu with the candidates.
            var menu = new GLib.Menu ();
            foreach (var candidate in candidates) {
                // GMenu labels interpret underscores as mnemonics.
                var item = new MenuItem (candidate.replace ("_", "__"), null);
                item.set_action_and_target_value ("completion.select", new Variant.string (candidate));
                menu.append_item (item);
            }

            widget.menu_model = menu;
            widget.popup ();
        }

        private void on_entry_changed () {
            dismiss ();
        }

        private void on_entry_visibility_changed () {
            if (entry != null && !entry.visible)dismiss ();
        }

        private bool handle_key_pressed (uint keyval, uint keycode, Gdk.ModifierType mods) {
            if (visible && keyval == Gdk.Key.Escape) {
                dismiss (true);
                return true;
            }

            return false; // Not handled by this widget
        }
    }
}