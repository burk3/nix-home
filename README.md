# a home-manager setup for workstations and headless stuff.

As I move more and more dotfiles into home-manager, I want to be able to deploy in lots of places. This is both boxes with a monitor and without.

This repo should probably live at `~/.config/home-manager`.

## Flags
Once cloned and put where **home-manager** is expecting, empty files in the `flags` dir will control some features of the configuration. For example, to enable the management of some GUI applications on a machine with a monitor, simply `touch flags/GUI` and some fun programs will be installed/configured!

### Flag: `GUI`
```
touch flags/GUI
```
Installs some terminals, media programs, and other things that wouldn't be core to a full desktop environment. Options for terminal emulators abound.

### Flag: `HYPR`
**Requires** `GUI`.

```
touch flags/HYPR flags/GUI
```

Mostly configured [hyprland](https://hyprland.org/) setup. You'll need hyprland installed on the system so it shows up as a valid session in your login thing. I use GDM for logging in and session selection. I also tend to have Gnome installed at the OS level as a fallback in case I really need a more "normal" desktop experience for something.

This also includes stuff I generally want working for any desktop environment, like `gnome-keyring` and setup to make it work as an ssh agent. I guess this flag could probably be named "desktop" or something like that.

