namespace Vaipe {
    public class Window : Adw.ApplicationWindow {
        private CommandEntry command_entry;

        public Window (Vaipe.Application application) {
            Object (application: application,
                    title: _("VAIPE"),
                    default_width: 800,
                    default_height: 600);

            var overlay = new Gtk.Overlay () {
                child = new Gtk.ScrolledWindow () {
                    child = new GtkSource.View ()
                }
            };

            command_entry = new CommandEntry (application.commands);

            var show_action = new SimpleAction ("show-command-entry", null);
            show_action.activate.connect (command_entry.show_command_entry);
            add_action (show_action);

            overlay.add_overlay (command_entry);

            var toolbar_view = new Adw.ToolbarView () {
                content = overlay
            };

            var echo_area = new EchoArea ();
            toolbar_view.add_bottom_bar (echo_area);

            var message_action = new SimpleAction ("message", GLib.VariantType.STRING);
            message_action.activate.connect ((arg) => {
                var message = arg.get_string (null);
                echo_area.message (message);
            });
            add_action (message_action);

            content = toolbar_view;
        }

        // Helper method to send a message to the echo area, via any child widget of the window
        public static void message (Gtk.Widget widget, string message) {
            if (!widget.activate_action ("win.message", "s", message)) {
                warning ("Could not activate win.message action");
            }
        }
    }
}