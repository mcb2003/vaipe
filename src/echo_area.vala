namespace Vaipe {
    // Gtk.Revealer is a sealed class, so we must derive from another widget instead
    public class EchoArea : Gtk.Box {
        private Gtk.Label message_label = new Gtk.Label("");
        private Gtk.Revealer revealer;

        public bool message_visible { get { return revealer.child_revealed; } }

        public EchoArea() {
            revealer = new Gtk.Revealer() {
                child = message_label,
                reveal_child = false,
                transition_type = Gtk.RevealerTransitionType.SLIDE_UP
            };
            append(revealer);
        }

        public void message(string message) {
            message_label.label = message;
            revealer.reveal_child = true;

            // Announce messages to screen readers via the window root (announcing from this EchoArea doesn't work, probably because its accessibility context hasn't been realised)
            if (root != null) {
                root.announce(message, Gtk.AccessibleAnnouncementPriority.MEDIUM);
            }
        }
    }
}