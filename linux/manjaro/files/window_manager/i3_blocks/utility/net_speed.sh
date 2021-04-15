#!/bin/bash

ORDER=$(speedtest-cli --json | jq '.download' | awk '{print int(log($1)/log(1000)) }')
SPEED=$(speedtest-cli --json | jq '.download' | awk '{printf("%4.2f",$1 / 1000^(int(log($1)/log(1000)))) }')

case $ORDER in
    0)
        echo "Not Connected" ;;
    1)
        echo "$SPEED Kbps" ;;
    2)
        echo "$SPEED Mbps" ;;
    3)
        echo "$SPEED Gbps" ;;
esac
