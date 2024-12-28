# a home-manager setup for workstations and headless stuff.

as I move more and more dotfiles into home-manager, I want to be able to deploy in lots of places. This is both boxes with a monitor and without.

I don't want to install/configure any GUI stuff on a server, for example, so I need a way to turn on GUI stuff. I do this with the `flags` dir. If you are on a box with a monitor (and want home-manager to do its thing), just `touch flags/GUI` and home-manager will do it's thing.
