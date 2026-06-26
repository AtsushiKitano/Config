#!/bin/bash

if [ $(uname) != "Darwin" ]; then
	echo "OS is not macOS"
	exit 1
fi

# 外部 tap の `brew trust` は Brewfile 冒頭の Ruby ブロックで自動実行される。
# 手動で /Applications に置かれた既存アプリと衝突しても上書きできるよう --force を渡す。
HOMEBREW_CASK_OPTS="--force" brew bundle --global
