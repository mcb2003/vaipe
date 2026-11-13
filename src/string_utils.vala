namespace Vaipe {
    public string longest_common_prefix (string[] strings) {
        if (strings.length == 0)return "";

        string common = strings[0];
        foreach (var value in strings) {
            while (!value.has_prefix (common)) {
                common = common.substring (0, common.index_of_nth_char (common.char_count () - 1));
            }
        }
        return common;
    }
}
