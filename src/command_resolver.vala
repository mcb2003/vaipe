namespace Vaipe {
    public class CommandResolver : Object {
        private HashTable<string, Command> commands;

        public CommandResolver () {
            commands = new HashTable<string, Command> (str_hash, str_equal);
        }

        public void add (Command command) {
            commands.insert (command.name, command);
        }

        public Command ? lookup (string command) {
            return commands.lookup (command);
        }

        public string[] complete (string prefix) {
            var names = commands.get_keys ();
            names.sort (strcmp);

            string[] matches = {};
            foreach (var name in names) {
                if (name.has_prefix (prefix)) {
                    matches += name;
                }
            }
            return matches;
        }
    }
}