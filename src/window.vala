namespace Vaipe {
    public class Window : Gtk.ApplicationWindow {
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
            show_action.activate.connect (() => command_entry.show_command_entry ());
            add_action (show_action);

            overlay.add_overlay (command_entry);

            child = overlay;
        }
    }
}