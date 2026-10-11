int main (string[] args) {
    Intl.setlocale ();

    var localedir = Environment.get_variable ("VAIPE_LOCALEDIR") ?? Vaipe.Config.LOCALEDIR;
    Intl.bindtextdomain (Vaipe.Config.GETTEXT_PACKAGE, localedir);
    Intl.bind_textdomain_codeset (Vaipe.Config.GETTEXT_PACKAGE, "UTF-8");
    Intl.textdomain (Vaipe.Config.GETTEXT_PACKAGE);

    return new Vaipe.Application ().run (args);
}