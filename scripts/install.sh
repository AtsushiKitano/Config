#!/bin//bash

if [ $(uname) = "Darwin" ]; then
	echo "carry out mac config"
	bash brew.sh
else
	echo "OS is not macOS"
fi
