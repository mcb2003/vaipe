namespace Vaipe {
    public class Application : Gtk.Application {
        public Application () {
            Object (application_id: "vip.thefake.vaipe");
        }

        protected override void startup () {
            base.startup ();
            GtkSource.init ();

            // Register window actions:
            set_accels_for_action("win.show-command-entry", {"<Control>slash"});
        }

        protected override void activate () {
            var window = active_window;
            if (window == null) {
                window = new Window (this);
            }
            window.present ();
        }
    }
}
