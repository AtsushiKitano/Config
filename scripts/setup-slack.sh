#!/bin/bash
# 1Password CLI 経由で Slack 認証情報を取得し ~/.authinfo に書き込む。
#
# 事前準備 (1度だけ):
#   1. 1Password に Login Item を作成する (タイトル: "Slack emacs")
#      フィールド:
#        - email   : <自分のメールアドレス>
#        - token   : <xoxc- で始まるトークン>
#        - cookie  : <xoxd- で始まる cookie>
#   2. `op signin` で CLI 認証を済ませる (アプリ連携でも可)。
#
# `op` リファレンスは環境変数 SLACK_OP_REF で上書き可能 (デフォルト: op://Private/Slack emacs)。
set -euo pipefail

if ! command -v op >/dev/null 2>&1; then
	echo "Error: 1Password CLI (op) が見つかりません。'brew install --cask 1password-cli' でインストールしてください。" >&2
	exit 1
fi

REF="${SLACK_OP_REF:-op://Private/Slack emacs}"
AUTHINFO="$HOME/.authinfo"

echo "=== Slack credential setup via 1Password ==="
echo "Reading from: $REF"

email=$(op read "$REF/email")
token=$(op read "$REF/token")
cookie=$(op read "$REF/cookie")

if [ -z "$email" ] || [ -z "$token" ] || [ -z "$cookie" ]; then
	echo "Error: 1Password から email/token/cookie のいずれかを取得できませんでした。" >&2
	exit 1
fi

# 既存エントリを削除して重複させない
if [ -f "$AUTHINFO" ]; then
	sed -i '' "/machine slack-emacs-token login $email/d" "$AUTHINFO"
	sed -i '' "/machine slack-emacs-cookie login $email/d" "$AUTHINFO"
fi

{
	echo "machine slack-emacs-token login $email password $token"
	echo "machine slack-emacs-cookie login $email password $cookie"
} >> "$AUTHINFO"

chmod 600 "$AUTHINFO"

echo "Done. Credentials written to $AUTHINFO (mode 600)."
echo "Restart Emacs (er) and press C-c s s to connect."
