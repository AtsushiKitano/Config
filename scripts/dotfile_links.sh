#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0)/.. && pwd)

for dotfile in $SCRIPT_DIR/dotfiles/.??* ; do
	[ $dotfile = "$SCRIPT_DIR/dotfiles/.Brewfile" ] && [ $(uname) != "Darwin" ] && continue
	ln -fnsv $dotfile $HOME
done

if [ $(uname) = "Darwin" ]; then
	ln -fnsv $SCRIPT_DIR/macos/Karabiner/karabiner.json $HOME/.config/karabiner/
	ln -fnsv $SCRIPT_DIR/macos/kitty.conf $HOME/.config/kitty/
fi

if type emacs > /dev/null 2>&1; then
	ln -fnsv $SCRIPT_DIR/Emacs/init.el $HOME/.emacs.d/
fi
