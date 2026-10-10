# Interaction Model

This document describes the slightly strange GUI layout of VAIPE and its unconventional (for a graphical application) set of interaction patterns for performing operations and ultimately, *hopefully*, getting work done.

## Why VAIPE Uses a Different Visual Layout

Traditional IDEs split one window into many panels, showing not just the file being edited but also ancillary tools such as file browsers, symbol outlines, build logs, embedded terminals, version control status information, toolbars containing  commands and operations, etc. I (@mcb2003) find this interface style quite unproductive to use with a screen reader.

Screen reader users cannot "glance around" the screen and take in many pieces of information representing the current state of the application at once. In the majority of cases, only one GUI widget may be focused at one time. Thus, the workflow of screen reader users like myself tends to more closely resemble a non-concurrent stack of tasks:

- First open and read some code,
- Reference some documentation,
- Edit the code based on information newly obtained from the documentation,
- Run a build command,
- Read the first error,
- Edit the code to fix it,
- Read the second error,
- Fix that
- ... and so on.

Of note is the observation that to make this workflow productive, one must not only remove as many user interface components as possible that the user must traverse to perform tasks, such as panels or dialogs filled with options, but also that the act of switching between activities, such as switching from an editor to documentation and back again, then switching to the output of a build command, must be made as low-friction as possible.

From these observations, a preferred user interface model emerges:

## Activities and pages

A distinction should be made between the "activities" a user is partaking in during any given VAIPE session and the "pages" that expose their content and operations on that content.

In VAIPE, an activity is a context holding a single unit of work. For example, opening a text file for editing starts an "editing activity"; Opening a terminal to run some commands might be a "terminal activity" and kicking off a compilation process may result in some form of "build activity".

Activities are abstract: they are not directly exposed in VAIPE's UI as tangible interface components. Some activities may be able to continue executing in the background, even when no page is currently visible that exposes them to the user. For example, it may be the case that kicking off a long compilation process can asynchronously start a background build activity, and only surface the results of the build, such as compilation errors, to the user once the build has completed or terminated.

A page represents a GUI view of an activity. Unlike abstract activities, a page is a tangible concept: the user can read, traverse and interact with the page in the form of graphical components and available commands and operations the user may perform on the page or its content. In VAIPE, most conventional pages appear as tabs and consume nearly the entire window area, with the exception of the tab bar and status bar. One activity may provide multiple views over the same content and state, by exposing multiple pages at once.

Some activities live longer than others. It is common, for instance, to keep a few terminal emulators open at all times so that one may run one-off commands quickly, keep tabs on system resources or monitor long running processes. Likewise, when implementing a new feature in a codebase that touches a handful of files, it makes sense to keep the files you are iteratively changing open in your editor.

By contrast, reading the documentation for a single function may only take a few minutes, after which you don't need to keep that reference open any more. Likewise when making a git commit, you needn't keep the editor used to compose the commit message around after the commit has been made.

There are also situations where it is advantageous rather than distracting to show the user multiple pages within a single tab. For instance, when editing Markdown documents, it is useful to be able to switch between inspecting the Markdown source code and the rendered result very quickly. It is also often useful to show both representations simultaneously, particularly if you are editing a document while also showing it to someone else.

As a result of these ideas, VAIPE adopts these loose guidelines:

- Long running activities should *usually* be exposed as tabbed pages consuming the entire window area by default. This includes editors, terminals, compiler output and other *mostly persistent* activities.
- Shorter lived *sidequest* activities, such as instantly getting documentation for the symbol under the cursor or composing a commit message *may* be exposed as temporary split-views, popovers or dialogs. However it will not be uncommon that the user wishes to keep these around for longer than usual (particularly for documentation references) so options should be provided to open them in full-windowed tabs instead.

## Interaction principles

- It is faster for a screen reader user to perform actions using keyboard shortcuts or textual commands than it is for them to traverse graphical buttons, checkboxes, text entry fields and other options.
- The number of keyboard shortcuts needed to switch between activities and pages should be minimised as much as possible, because switching contexts like this happens very often in a screen reader user's workflow. When switching, focus should be kept such that you can pick up right where you left off.

## Default Navigation Conventions

These are the common shortcuts most Linux programs implement, which many Linux screen reader users can and will expect. We should use these as the default shortcuts.

- Ctrl+tab to cycle through tabs in the order they were created (optionally configurable) and Ctrl+Shift+tab to cycle in reverse;
  - (Ctrl+page-up and Ctrl+page-down should do the same)
- Ctrl+Shift+page-up and Ctrl+Shift+page-down to reorder tabs;
- alt+1-0 to switch to the nth tab where n is the number pressed;
- Ctrl+w to close a tab, Ctrl+q to close the entire window;
- An as-yet unspecified, but very easy to press, keyboard shortcut that flip-flops between the two most recently used tabs.

## Choosing an Interaction Pattern

- Where actions do not need any modifying options, such as "save" which always saves the current editor contents to the file associated with this editor activity, keyboard shortcuts such as Ctrl+s are *usually* the most appropriate UX.
  - Audible feedback, in the form of earcons or spoken operation status, is often useful here to indicate whether the operation succeeded or failed.
- Where actions require only one or two pieces of additional input or configuration, such as "open" where the file to open must be specified, a keyboard shortcut like Ctrl+o that automatically prompts the user for the required input is *usually* the most appropriate UX.
  - Sometimes this can be improved with prefix arguments as used by Vim and Emacs, such as prefixing a "delete line" command with the number 4 to delete 4 lines instead of 1.
- Where actions have many configuration options and/or arguments, textual commands, similar to those used by Unix shells, festooned with command-line options such as "--force", "-f" or "--port=1234", are *usually* the most appropriate UX.
  - This is preferable to dialogs filled with options because the user need only specify the options they wish to change from their defaults.
  - Command entry can be accelerated further with intelligent tab completion, and by allowing the user to change the defaults for options where appropriate.

## Action Feedback

It is important that the user knows what the outcome of performing an action or executing a command was. For many operations, the outcome is obvious (if, for instance, pressing Ctrl+n opens a new, empty editor into which one can start writing, the keyboard focus change caused by the new tab and editor control being created is usually enough to notify the user that their command was successful.

However, some operations do not have such an obvious effect on the environment the user is working in, and this is where so many existing applications get things wrong when it comes to exposing the outcome of such operations to screen reader users. For example, pressing "save" in many editors might clear a "modified" flag in the title bar or status line if the save succeeded, but very few of them notify users of assistive technologies that the save operation succeeded.

In the case of save, since success is usually expected and failure is a critical issue the user must be notified about, playing a "successfully saved" earcon on success and opening a modal warning dialog, accompanied by a "warning" earcon on failure, is probably the best UX design.

Earcons (auditory sound icons) in particular are criminally under-utilised in modern software. While it is understandable that some users may find their computer playing constant sounds annoying, it is nevertheless baffling that more software doesn't at least *support* playing earcons to indicate the occurrence of particular events.

Earcons are particularly useful to screen reader users because they increase the amount of information that can be conveyed at once. While screen reader users often set their speech rate to be as fast as they can understand it, speech is a naturally one-dimensional medium that can only provide so much information in a given period of time. Visuals offer a much higher bandwidth medium for imparting information, but in lieu of them being usable by screen reader users, earcons provide an additional channel of information that can be conveyed at the same time as speech: e.g. you can simultaneously hear an earcon indicating compilation success and understand that your build just finished, while continuing to read the code you're working on with your speech synthesiser.

For these reasons, earcons should be used in VAIPE to indicate the results of long and short running operations alike, whether they are synchronous (such as saving the current file) or asynchronous (such as the completion of a build process executing in the background).