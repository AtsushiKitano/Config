#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0)/.. && pwd)

for dotfile in $SCRIPT_DIR/dotfiles/.??* ; do
	[ $dotfile = "$SCRIPT_DIR/dotfiles/.Brewfile" ] && [ $(uname) != "Darwin" ] && continue
	ln -fnsv $dotfile $HOME
done

if [ $(uname) = "Darwin" ]; then
	ln -fnsv ../macos/Karabiner/karabiner.json $HOME/.config/karabiner/
fi

if type emacs > /dev/null 2>&1; then
	ln -fnsv ../Emacs/init.el $HOME/.emacs.d/
fi
