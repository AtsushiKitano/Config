#!/bin/bash

if [ $(uname) != "Darwin" ]; then
	echo "OS is not macOS"
	exit 1
fi

brew trust koekeishiya/formulae
brew trust railwaycat/emacsmacport
brew trust d12frosted/emacs-plus

brew bundle --global
