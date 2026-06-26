#!/bin/bash
set -euo pipefail

if [ "$(uname)" != "Darwin" ]; then
	echo "OS is not macOS"
	exit 1
fi

# 初回 bootstrap 時は PATH に Homebrew が入っていないので shellenv を eval する。
if ! command -v brew >/dev/null 2>&1; then
	if [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -x /usr/local/bin/brew ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	else
		echo "Homebrew not found. Install it from https://brew.sh first."
		exit 1
	fi
fi

# スクリプト自身からリポジトリの Brewfile を参照する (symlink 依存を排除)。
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$SCRIPT_DIR/../dotfiles/.Brewfile"

# 外部 tap の `brew trust` は Brewfile 冒頭の Ruby ブロックで自動実行される。
# 手動で /Applications に置かれた既存アプリと衝突しても上書きできるよう --force を渡す。
HOMEBREW_CASK_OPTS="--force" brew bundle --file="$BREWFILE"
