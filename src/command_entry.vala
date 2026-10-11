namespace Vaipe {
    public class CommandEntry : Gtk.Entry {
        private weak Gtk.Widget? previous_focus;

        public CommandEntry () {
            Object (placeholder_text: _("Enter a command"),
    halign: Gtk.Align.FILL,
    valign: Gtk.Align.END,
    hexpand: true,
        visible: false);

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
            if (visible) return;

            // Save current focus
            var root = get_root ();
            previous_focus = root == null ? null : root.get_focus ();

            visible = true;
                        grab_focus ();
        }

        public void hide_command_entry (bool restore_focus = true) {
            if (!visible) return;

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
    }
}