namespace Vaipe {
    // Gtk.Revealer is a sealed class, so we must derive from another widget instead
    public class EchoArea : Gtk.Box {
        private Gtk.Label message_label = new Gtk.Label("") {
            wrap = true,
        };
        private Gtk.Revealer revealer;
        private uint? current_timeout;

        public bool message_visible { get { return revealer.child_revealed; } }

        public EchoArea() {
            revealer = new Gtk.Revealer() {
                child = message_label,
                reveal_child = false,
                transition_type = Gtk.RevealerTransitionType.SLIDE_UP
            };
            append(revealer);
        }

        public void message(string message, uint timeout = 3000) {
            // Cancel any existing hide timeout
            if (current_timeout != null) {
                Source.remove(current_timeout);
                current_timeout = null;
            }

            message_label.label = message;
            revealer.reveal_child = true;

            // Start a timer to hide it again
            current_timeout = Timeout.add_once(timeout, () => {
                current_timeout = null;
                revealer.reveal_child = false;
            });

            // Announce messages to screen readers via the window root (announcing from this EchoArea doesn't work, probably because its accessibility context hasn't been realised)
            if (root != null) {
                root.announce(message, Gtk.AccessibleAnnouncementPriority.MEDIUM);
            }
        }
    }
}