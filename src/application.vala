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

            var new_window = new GLib.SimpleAction ("new-window", null);
            new_window.activate.connect (() => {
                var win = new Window (this);
                win.present ();
            });
            add_action (new_window);

            commands.add (new Command ("quit", "app.quit"));
            commands.add (new Command ("new-window", "app.new-window"));
            commands.add (new Command ("open", "open", Command.bind_string_arg));
            commands.add (new Command ("save", "save"));

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