namespace Vaipe {
    public class Window : Adw.ApplicationWindow {
        private CommandEntry command_entry;
        private EchoArea echo_area;

        static construct {
            install_action ("win.show-command-entry", null, handle_show_command_entry);
            install_action ("win.message", "s", handle_message);
        }

        public Window (Vaipe.Application application) {
            Object (application: application,
                    title: _("VAIPE"),
                    default_width: 800,
                    default_height: 600);

            var overlay = new Gtk.Overlay () {
                child = new Gtk.ScrolledWindow () {
                    child = new Editor.View (new Editor.Document ())
                }
            };

            command_entry = new CommandEntry (application.commands);
            overlay.add_overlay (command_entry);

            var toolbar_view = new Adw.ToolbarView () {
                content = overlay
            };

            echo_area = new EchoArea ();
            toolbar_view.add_bottom_bar (echo_area);

            content = toolbar_view;
        }

        // Helper method to send a message to the echo area, via any child widget of the window
        public static void message (Gtk.Widget widget, string message) {
            if (!widget.activate_action ("win.message", "s", message)) {
                warning ("Could not activate win.message action");
            }
        }

        private static void handle_show_command_entry (Gtk.Widget widget, string name, Variant? arg) requires (arg == null) {
            var window = (Window) widget;
            window.command_entry.show_command_entry ();
        }

        private static void handle_message (Gtk.Widget widget, string name, Variant? arg) requires (arg != null) {
            var window = (Window) widget;
            window.echo_area.message (arg.get_string (null));
        }
    }
}
