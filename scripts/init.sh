#!/bin/bash

if [ $(uname) = "Darwin" ]; then
	echo "carry out mac config"
	bash macos/init.sh
else
	echo "OS is not macOS"
fi
