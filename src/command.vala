namespace Vaipe {
    public class Command : Object {
        public string name { get; construct; }
        public string action_name { get; construct; }

        public Command (string name, string action_name) {
            Object(name: name, action_name: action_name);
        }
    }
}