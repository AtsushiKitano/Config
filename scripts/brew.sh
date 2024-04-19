#!/bin/bash

if [ $(uname) != "Darwin" ]; then
	echo "OS is not macOS"
	exit 1
fi

brew bundle --global
