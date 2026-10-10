# VAIPE - VIP's Accessible, Independent Programming Environment

VAIPE is my dream Linux-native programming environment, written in Vala and powered by GTK, GTK Source View and VTE. It aims to provide a distraction free, stupidly simple workspace for working on code and running commands and terminal applications.

## Really? Yet Another Text Editor?

For me, yes. I started this project for myself: I have been dissatisfied with all the other text editor / IDE applications out there. Most of them are either flexible but complex (Emacs), efficient but minimal (Vim/Neovim), user friendly but bloated (VS Code) or some combination of the above. I have (successfully) used them all, and they're not bad projects, far from it! But they don't suit me and my way of working.

Furthermore, I am a blind screen reader user who seldom uses a mouse, lives out of a terminal and wants my *entire screen* to be filled with what I'm currently doing. I don't want my editor to show me build logs, symbol outlines, file browsers, AI chat inputs, git status and embedded terminal panels surrounding the text I'm currently editing. Such a segmented interface, composed of dockable panels, works for sighted people because they can glance around the screen to quickly assess the state of an entire project and the subsection of it they're currently focused on. For a screen reader user however, I think a better interface is one where the user can focus on one thing at a time, and where context switching to another editor, terminal or tool is a very quick operation (ideally a single key press).

Accessibility is also a key part of the VAIPE mission. I almost care more about how VAIPE's interface feels to use with speech, than I do about how easy it is to use by its appearance. Menus and dialogs work well for sighted users of all kinds, including, with sufficient care payed to UX design, to those who have never used your program before. They're also great for discoverability. But VAIPE is built, initially at least, for *me and me only*, and for a blind programmer and power user, keyboard shortcuts, commands and tab-completion are nearly always faster.

## Why Linux Only?

First off, there is no reason somebody couldn't port VAIPE to run on Windows, macOS or any other platform that GTK and the Gnome platform libraries support. Indeed, if for some reason you feel like doing so, I'll gladly merge pull requests adding support for other platforms. I, however, use various flavours of GNU/Linux as my daily-driver OS, so my primary target is the Linux desktop, including the Orca screen reader and at-spi API for accessibility.

I chose GTK and the Gnome stack because I like its programming model and since I'm only targetting Linux / *nix, it allows me to integrate VAIPE with the desktop platform to a greater degree than cross-platform GUI toolkits like wxWidgets, particularly when it comes to accessibility. I chose GTK over QT specifically because of VTE, which is the most (and one of the only) terminal emulator widgets that is accessible with Orca. GTK Source View is also a boon because it means I don't have to build the syntax highlighting, gutter markers and common user interface guidelines for text/code editing on day 1, and I can modify them if and when I need to instead.

## Installation

Like many Gnome apps, we use the Meson build system:

### Clone the repository

```sh
git clone https://github.com/mcb2003/vaipe
cd vaipe
```

### Configure

```sh
meson setup build
```

### Compile

```sh
meson compile -C build
```

### Install

```sh
sudo meson install -C build
```

## License

VAIPE is licensed under the GNU General Public License, *version 3.0 only*.

Copyright (C) 2026  Michael Connor Buchan <mikey@blindcomputing.org>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
