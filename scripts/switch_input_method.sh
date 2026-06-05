#!/bin/bash
# フォーカスが当たっているアプリに応じて入力ソースを切り替える
# Emacs: 英字 (ABC) / その他: AquaSKK

APP=$(yabai -m query --windows --window 2>/dev/null \
  | python3 -c "import sys,json; print(json.load(sys.stdin).get('app',''))" 2>/dev/null)

if [ "$APP" = "Emacs" ]; then
    macism com.apple.keylayout.ABC
else
    macism jp.sourceforge.inputmethod.aquaskk
fi
