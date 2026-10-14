namespace Vaipe.Editor {
    class View : GtkSource.View {
        public Document document { get; construct set; }

        static construct {
            install_action ("open", "s", handle_open);
            install_action ("save", null, handle_save);

            add_binding_action (Gdk.Key.S, Gdk.ModifierType.CONTROL_MASK, "save", null);
        }

        public View (Document document) {
            Object (
                    document: document,
                    buffer: document.buffer,
                    auto_indent: true,
                    highlight_current_line: true,
                    monospace: true,
                    show_line_numbers: true,
                    smart_backspace: true,
                    smart_home_end: GtkSource.SmartHomeEndType.BEFORE
            );
        }

        private async void open (GLib.File file) {
            // Construct a document pointing at the new file
            var doc = new Document () {
                location = file
            };

            try {
                if (yield doc.load (null)) {
                    // Replace the current document
                    // Todo: ask to save modified documents
                    this.document = doc;
                    this.buffer = doc.buffer;
                } else {
                    Window.message (this, _("Could not load file %s").printf (file.get_parse_name ()));
                }
            } catch (Error e) {
                Window.message (this, _("Could not load file %s: %s").printf (file.get_parse_name (), e.message));
            }
        }

        private async void save () {
            if (document.location == null) {
                Window.message (this, _("Cannot save a document with no location"));
                return;
            } else if (document.read_only) {
                Window.message (this, _("File is read only"));
                return;
            }

            try {
                if (yield document.save (null)) {
                    Window.message (this, _("Saved"));
                } else {
                    Window.message (this, _("Could not save file %s").printf (document.location.get_parse_name ()));
                }
            } catch (Error e) {
                Window.message (this, _("Could not save file %s: %s").printf (document.location.get_parse_name (), e.message));
            }
        }

// Action handlers:

        private static void handle_open (Gtk.Widget widget, string name, Variant? arg) requires (arg != null) {
            string filename = arg.get_string (null);
            // We use new_for_commandline_arg because it handles both local paths and URIs
            var file = GLib.File.new_for_commandline_arg (filename);

            var self = (View) widget;
            self.open.begin (file);
        }

        private static void handle_save (Gtk.Widget widget, string name, Variant? arg) requires (arg == null) {
            var self = (View) widget;
            self.save.begin ();
        }
    }
}