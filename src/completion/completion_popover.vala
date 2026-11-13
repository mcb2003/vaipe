namespace Vaipe {
    // The UI for tab completion.
    public class CompletionPopover : Object {
        private Gtk.PopoverMenu menu;
        private weak Gtk.Entry? entry;
        private Gtk.EventControllerKey key_controller;

        public bool visible { get { return menu.visible; } }
        public CompletionModel? model {
            get { return menu.menu_model as CompletionModel; }
            set {
                if (model == value)return;
                if (model != null)model.items_changed.disconnect (on_model_changed);
                menu.menu_model = value;
                if (value != null)value.items_changed.connect (on_model_changed);
                on_model_changed ();
            }
        }

        public signal void candidate_selected (string candidate);
        public signal void closed ();

        public CompletionPopover (Gtk.Entry entry) {
            this.entry = entry;
            menu = new Gtk.PopoverMenu.from_model (null) {
                position = Gtk.PositionType.TOP
            };

            var actions = new SimpleActionGroup ();
            var select = new SimpleAction ("select", VariantType.STRING);
            select.activate.connect ((parameter) => {
                dismiss (true);
                candidate_selected (parameter.get_string ());
            });
            actions.add_action (select);
            menu.insert_action_group ("completion", actions);

            menu.set_parent (entry);
            menu.closed.connect (() => closed ());

            // Dismiss the popover when the entry changes or loses focus.
            entry.changed.connect (on_entry_changed);
            entry.notify["cursor-position"].connect (on_entry_changed);
            entry.notify["selection-bound"].connect (on_entry_changed);
            entry.notify["visible"].connect (on_entry_visibility_changed);

            key_controller = new Gtk.EventControllerKey ();
            key_controller.propagation_phase = Gtk.PropagationPhase.CAPTURE;
            key_controller.key_pressed.connect (handle_key_pressed);
            ((Gtk.Widget) menu).add_controller (key_controller);
        }

        protected override void dispose () {
            if (menu.get_parent () != null) {
                // Must do this because we used set_parent.
                menu.unparent ();
            }

            base.dispose ();
        }

        public void dismiss (bool restore_focus = false) {
            if (!visible)return;
            int cursor = entry == null ? 0 : entry.get_position ();
            menu.popdown ();
            if (restore_focus && entry != null) {
                entry.grab_focus_without_selecting ();
                entry.set_position (cursor);
            }
        }

        public void show_candidates () {
            if (entry == null || model == null || model.get_n_items () <= 1) {
                dismiss ();
                return;
            }
            menu.popup ();
        }

        private void on_model_changed () {
            if (!visible)return;
            // Only keep the menu open while completion is ambiguous.
            if (model == null || model.get_n_items () <= 1) {
                dismiss (true);
            } else {
                // The focused candidate may have been removed.
                var focus = menu.root == null ? null : menu.root.get_focus ();
                if (focus == null || !focus.is_ancestor (menu)) {
                    menu.child_focus (Gtk.DirectionType.TAB_FORWARD);
                }
            }
        }

        private void on_entry_changed () {
            dismiss ();
        }

        private void on_entry_visibility_changed () {
            if (entry != null && !entry.visible)dismiss ();
        }

        private bool handle_key_pressed (uint keyval, uint keycode, Gdk.ModifierType mods) {
            if (!visible || entry == null)return false;

            if (keyval == Gdk.Key.Escape) {
                dismiss (true);
                return true;
            }

            return false; // Not handled by this widget
        }
    }
}
