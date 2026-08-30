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

# Chrome 等の自己更新型 cask は Homebrew の管理バージョンと実体がズレ、
# `brew bundle` の cask アップグレードが Caskroom の残骸アプリと衝突して
#   Error: ... It seems there is already an App at '.../Caskroom/<ver>/*.app'.
# で失敗する。`brew bundle` は upgrade 時に HOMEBREW_CASK_OPTS="--force" を
# 確実には適用しないため、bundle の前に outdated な cask を明示的に
# `brew upgrade --cask --force` して残骸を上書き解消しておく。
# 注: /Applications への上書きに sudo が必要な場合があるので、make sync /
# make install は必ず端末から (sudo がパスワードを聞ける状態で) 実行すること。
outdated_casks="$(brew outdated --cask --quiet 2>/dev/null || true)"
if [ -n "$outdated_casks" ]; then
	echo "[brew] Force-upgrading outdated casks:"
	echo "$outdated_casks" | sed 's/^/  - /'
	# shellcheck disable=SC2086
	brew upgrade --cask --force $outdated_casks
fi

# 外部 tap の `brew trust` は Brewfile 冒頭の Ruby ブロックで自動実行される。
# 手動で /Applications に置かれた既存アプリと衝突しても上書きできるよう --force を渡す。
HOMEBREW_CASK_OPTS="--force" brew bundle --file="$BREWFILE"
