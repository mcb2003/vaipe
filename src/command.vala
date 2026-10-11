namespace Vaipe {
    public delegate Variant ? CommandArgumentBinder (string? remaining);

    public class Command : Object {
        public string name { get; construct; }
        public string action_name { get; construct; }

        private CommandArgumentBinder? binder;

        public Command (string name, string action_name, owned CommandArgumentBinder? binder = null) {
            Object (name : name, action_name : action_name);
            this.binder = (owned) binder;
        }

        public bool activate (Gtk.Widget focus, string? remaining) {
            return focus.activate_action_variant (action_name, bind_args (remaining));
        }

        protected virtual Variant ? bind_args (string? remaining) {
            if (binder != null) {
                return binder (remaining);
            }

            return null; // Pass no arguments
        }
    }
}