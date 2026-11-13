namespace Vaipe {
    // A live set of completions, exposed directly as a menu model.
    public abstract class CompletionModel : GLib.MenuModel {
        public string common_prefix {
            owned get {
                int count = get_n_items ();
                if (count == 0)return "";

                string common = get_completion (0);
                for (int i = 1; i < count && common.length > 0; i++) {
                    string completion = get_completion (i);
                    while (!completion.has_prefix (common)) {
                        common = common.substring (0, common.index_of_nth_char (common.char_count () - 1));
                    }
                }
                return common;
            }
        }

        public abstract void refilter (string prefix);
        public abstract string get_completion (int position);

        public override bool is_mutable () {
            return true;
        }

        public override void get_item_attributes (int item_index, out HashTable<string, Variant>? attributes) {
            string completion = get_completion (item_index);
            attributes = new HashTable<string, Variant> (str_hash, str_equal);
            // Menu labels interpret underscores as mnemonics.
            attributes.insert ("label", new Variant.string (completion.replace ("_", "__")));
            attributes.insert ("action", new Variant.string ("completion.select"));
            attributes.insert ("target", new Variant.string (completion));
        }

        public override void get_item_links (int item_index, out HashTable<string, GLib.MenuModel> links) {
            links = new HashTable<string, GLib.MenuModel> (str_hash, str_equal);
        }
    }
}
