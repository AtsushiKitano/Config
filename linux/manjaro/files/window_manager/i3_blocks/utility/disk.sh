#!/bin/sh

DIR="${BLOCK_INSTANCE:-$HOME}"

df -h -P -l $DIR | awk 'NR>1{print $4,$5}' | tr -d % |awk '{rest=100-$2} END {print $1"("rest"%)"}'
