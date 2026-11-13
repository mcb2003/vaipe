namespace Vaipe {
    // The model and character range for one completion attempt.
    public class CompletionContext : Object {
        public CompletionModel model { get; private set; }
        public int start { get; private set; }
        public int end { get; private set; }
        public string prefix { get; private set; }

        public CompletionContext (CompletionModel model, int start, int end, string prefix) {
            this.model = model;
            this.start = start;
            refilter (prefix, end);
        }

        public void refilter (string prefix, int end) {
            this.prefix = prefix;
            this.end = end;
            model.refilter (prefix);
        }

        public void replace (Gtk.Editable entry, string completion, bool append_space = false) {
            string text = entry.text;
            string before = text.substring (0, text.index_of_nth_char (start));
            string after = text.substring (text.index_of_nth_char (end));
            if (append_space && after.length == 0) after = " ";
            entry.text = before + completion + after;
            int cursor = start + completion.char_count ();
            if (append_space && after.has_prefix (" ")) cursor++;
            entry.set_position (cursor);
        }
    }
}
