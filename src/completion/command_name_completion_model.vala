namespace Vaipe {
    public class CommandNameCompletionModel : CompletionModel {
        private CommandResolver commands;
        private string[] matches = {};

        public CommandNameCompletionModel (CommandResolver commands) {
            this.commands = commands;
        }

        public override void refilter (string prefix) {
            var candidates = commands.complete (prefix);
            // Keep surviving candidates intact so GTK can preserve their menu items.
            for (int i = 0; i < candidates.length; i++) {
                int existing = i;
                while (existing < matches.length && matches[existing] != candidates[i])existing++;
                if (existing < matches.length) {
                    if (existing > i)splice (i, existing - i, {});
                } else {
                    splice (i, 0, { candidates[i] });
                }
            }
            if (matches.length > candidates.length)splice (candidates.length, matches.length - candidates.length, {});
        }

        public override string get_completion (int position) {
            return matches[position];
        }

        public override int get_n_items () {
            return matches.length;
        }

        private void splice (int position, int removed, string[] added) {
            string[] updated = {};
            for (int i = 0; i < position; i++)updated += matches[i];
            foreach (var candidate in added)updated += candidate;
            for (int i = position + removed; i < matches.length; i++)updated += matches[i];
            matches = updated;
            items_changed (position, removed, added.length);
        }
    }
}