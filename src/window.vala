namespace Vaipe {
    public class Window : Gtk.ApplicationWindow {
        public Window (Gtk.Application application) {
            Object (application: application,
                    title: "VAIPE",
                    default_width: 800,
                    default_height: 600);

            child = new Gtk.ScrolledWindow () {
                child = new GtkSource.View ()
            };
        }
    }
}
