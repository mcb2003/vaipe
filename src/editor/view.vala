namespace Vaipe.Editor {
    class View : GtkSource.View {
        public Document document { get; construct set; }

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
    }
}