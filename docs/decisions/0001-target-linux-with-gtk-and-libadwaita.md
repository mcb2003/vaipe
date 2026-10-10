# Target Linux with Gtk and Libadwaita

- **Status**: accepted

## Context

VAIPE is developed primarily for me, @mcb2003. I use Linux as my primary OS, so to keep the project's scope smaller, cross-platform compatibility is not a goal. Accessibility with my primary screen reader, Orca, is also a major design constraint, and I want to deeply integrate VAIPE with Linux desktop and general Unix facilities rather than hide them. Where possible, VAIPE should also use existing libraries and technologies if they provide the user experience the project is targeting.

## Decision

- *Target Linux only*: we may use Linux-specific APIs, libraries and tools;
- *Use GTK4 as its GUI toolkit*: so that it integrates with the rest of the GNOME platform and because GTK is the most accessible toolkit for my use-case on Linux;
- *Use libadwaita for standard application-shell widgets*: however making VAIPE follow all GNOME UI guidelines is secondary to making it work in a way that is most productive for me, a blind, screen reader using programmer;
- *Prefer native GNOME ecosystem components*: such as GTK widgets (both built into GTK and available as extra libraries), GtkSourceView, VTE and GIO to avoid rewriting widgets that are already robust, accessible and provide the features we need.

## Consequences

- Portability to other platforms will not be considered when implementing new features;
- VAIPE can use Unix, Linux and GNOME platform facilities where doing so allows it to be more useful according to the project's goals;
- GTK / libadwaita convensions may be explicitly ignored where they conflict with VAIPE's requirements for accessibility or workflow.