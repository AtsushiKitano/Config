#!/bin/sh

FILEPATH=$HOME/"Library/Application Support/AquaSKK"
LOCALPATH=$PWD
FILES=(sub-rule.desc \
            arrow.rule \
      )

for FILE in ${FILES[@]}; do
    ln -s "$LOCALPATH"/$FILE "$FILEPATH"/$FILE
done
