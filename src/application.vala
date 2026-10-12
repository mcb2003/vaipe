namespace Vaipe {
    public class Application : Adw.Application {
        public CommandResolver commands;

        public Application () {
            Object (application_id: "vip.thefake.vaipe");

            commands = new CommandResolver ();
        }

        protected override void startup () {
            base.startup ();
            Adw.init ();
            GtkSource.init ();

            var quit = new GLib.SimpleAction ("quit", null);
            quit.activate.connect (this.quit);
            add_action (quit);
            commands.add (new Command ("quit", "app.quit"));

            // Set keyboard shortcuts for actions:
            set_accels_for_action ("app.quit", { "<Control>q" });
            set_accels_for_action ("win.show-command-entry", { "<Control>slash" });
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