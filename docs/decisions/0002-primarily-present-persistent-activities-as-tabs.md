# Primarily Present Persistent Activities as Tabs

- **Status**: accepted

## Context

VAIPE's interaction model is designed primarily around screen-reader use. Traditional IDE layouts divide the window into many simultaneously visible panels and controls, but this provides little benefit to a screen reader user as they almost always interact with one focused widget at a time. Putting more GUI controls on the screen at once is also a fantastic way to painfully slow down a screen reader user's ability to navigate the application. Thus, rapidly switching between activities is more important than keeping many tools visible simultaneously.

This rationale and the resulting interaction principles are comprehensively described in [Interaction Model](../interaction-model.md).

## Decision

- Persistent activities should normally be exposed through pages presented as tabs that take up the vast majority of the window;
- Activities and pages are distinct concepts: an "activity" represents a unit of work. A "page" is a GUI view of that activity;
- An activity may expose more than one page;
- Content that is temporary or that supports or is tightly-coupled to the main page  may instead be shown using transient UI such as split views, popovers or dialogs.

## Consequences

- Switching between tabs becomes a central navigation operation and must be fast, flexible and predictable (getting this wrong will directly lead to an unproductive workflow);
- Some activities may continue running without any visible page (we might need to expose some sort of "retrieve" and "cancel" mechanism to surface these later);
- Most content that other IDEs would place in panels will appear as
  tabs instead.
- Exceptions to the tab model are allowed if they make sense for the workflow of a screen reader user, particularly if this is configurable.