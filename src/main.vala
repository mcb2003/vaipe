int main (string[] args) {
    Intl.setlocale ();
    Intl.bindtextdomain (Vaipe.Config.GETTEXT_PACKAGE, Vaipe.Config.LOCALEDIR);
    Intl.bind_textdomain_codeset (Vaipe.Config.GETTEXT_PACKAGE, "UTF-8");
    Intl.textdomain (Vaipe.Config.GETTEXT_PACKAGE);

    return new Vaipe.Application ().run (args);
}