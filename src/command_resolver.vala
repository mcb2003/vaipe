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
    }
}