namespace Vaipe {
    public errordomain CommandError {
        INVALID_ARGUMENTS
    }

    public delegate Variant ? CommandArgumentBinder (string? remaining) throws CommandError;

    public class Command : Object {
        public string name { get; construct; }
        public string action_name { get; construct; }

        private CommandArgumentBinder? binder;

        public Command (string name, string action_name, owned CommandArgumentBinder? binder = null) {
            Object (name : name, action_name : action_name);
            this.binder = (owned) binder;
        }

        public bool activate (Gtk.Widget focus, string? remaining) throws CommandError {
            return focus.activate_action_variant (action_name, bind_args (remaining));
        }

        protected virtual Variant ? bind_args (string? remaining) throws CommandError {
            if (binder != null) {
                return binder (remaining);
            }

            return bind_no_args (remaining);
        }

        // Helpers for common ways to bind command arguments to action Variant arguments.

        public static Variant ? bind_no_args (string? remaining) throws CommandError {
            if (remaining != null) {
                throw new CommandError.INVALID_ARGUMENTS ("This command takes no arguments");
            }
            return null;
        }
    }
}
