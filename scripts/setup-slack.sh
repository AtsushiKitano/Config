#!/bin/bash
# Setup Slack credentials in ~/.authinfo for emacs-slack

AUTHINFO="$HOME/.authinfo"

echo "=== Slack credential setup for emacs-slack ==="
echo ""
echo "Before running this script, obtain the following from https://app.slack.com :"
echo "  Token  : DevTools Console → run the JS snippet in README.md"
echo "  Cookie : DevTools Application → Cookies → app.slack.com → 'd' value"
echo ""

read -rp "Email address : " email
read -rp "Token  (xoxc-): " token
read -rp "Cookie (xoxd-): " cookie

if [[ -z "$email" || -z "$token" || -z "$cookie" ]]; then
  echo "Error: all fields are required." >&2
  exit 1
fi

# Remove existing entries to avoid duplicates
if [[ -f "$AUTHINFO" ]]; then
  sed -i '' "/machine slack-emacs-token login $email/d" "$AUTHINFO"
  sed -i '' "/machine slack-emacs-cookie login $email/d" "$AUTHINFO"
fi

{
  echo "machine slack-emacs-token login $email password $token"
  echo "machine slack-emacs-cookie login $email password $cookie"
} >> "$AUTHINFO"

chmod 600 "$AUTHINFO"

echo ""
echo "Done. Credentials written to $AUTHINFO"
echo "Restart Emacs and press C-c s s to connect."
