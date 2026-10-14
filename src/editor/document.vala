namespace Vaipe.Editor {
    class Document : GtkSource.File {
        public GtkSource.Buffer buffer { get; construct set; }

        public Document (GtkSource.Buffer buffer = new GtkSource.Buffer (null)) {
            this.buffer = buffer;
        }

        public Document.from_file (GLib.File file) {
            Object (location: file);
            this.buffer = new GtkSource.Buffer (null);
        }

        public async bool load (Cancellable? cancellable = null) throws Error {
            var loader = new GtkSource.FileLoader (buffer, this);
            return yield loader.load_async (0, cancellable, null);
        }

        public async bool save (Cancellable? cancellable = null) throws Error {
            var saver = new GtkSource.FileSaver (buffer, this);
            return yield saver.save_async (0, cancellable, null);
        }
    }
}