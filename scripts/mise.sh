#!/bin/bash
set -euo pipefail

# 初回 bootstrap 時は PATH に Homebrew (mise) が入っていないので補完する。
if ! command -v mise >/dev/null 2>&1; then
	if [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -x /usr/local/bin/brew ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
fi

if ! command -v mise >/dev/null 2>&1; then
	echo "mise is not installed. Install it from https://mise.jdx.dev"
	exit 1
fi

# ~/.config/mise/config.toml が symlink されている前提 (`make link-mise`)。
mise install
