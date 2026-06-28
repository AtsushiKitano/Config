#!/bin/bash
# launchd から呼ばれる Emacs daemon ラッパー。
# 前回の daemon が異常終了した場合、サーバソケットが TMPDIR 配下に残り、
# 新しい daemon が `Unable to start the Emacs server` で起動失敗 → KeepAlive
# でループする問題が起きるため、起動前に dangling socket を掃除する。
set -euo pipefail

HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"
EMACS="$HOMEBREW_PREFIX/bin/emacs"
EMACSCLIENT="$HOMEBREW_PREFIX/bin/emacsclient"

SOCK_DIR="${TMPDIR:-/tmp}/emacs$(id -u)"
SOCK="$SOCK_DIR/server"

if [ -S "$SOCK" ]; then
	if ! "$EMACSCLIENT" -s "$SOCK" --eval t >/dev/null 2>&1; then
		rm -f "$SOCK"
	fi
fi

exec "$EMACS" --fg-daemon
