#!/bin/bash

if !(type mise > /dev/null 2>&1); then
	echo "mise is not installed. Install it from https://mise.jdx.dev"
	exit 1
fi

mise install
