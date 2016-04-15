#!/usr/bin/env bash

CONFIG="./config.sh"

if [ -e $CONFIG ]; then
    . "$CONFIG"
else
    echo MIssing config \"$CONFIG\"
    exit 12385
fi

sed -i -e 's/ .*\. //g' -e 's/[\[]//g' -e 's/\]//g' -e 's/\s/-/g' -e 's/>accn|/>accn-/g' -e 's/|//g' $CONTIGS
