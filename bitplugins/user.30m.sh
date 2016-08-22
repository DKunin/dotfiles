#!/bin/bash

# Wakatime
# BitBar plugin
#
# by Dkunin
#
# Displays time of waka
echo -n white | nc -4u -w0 localhost 1738
NODE=/Users/dikunin/.nvm/versions/node/v4.2.3/bin/node
WAKACLI=/Users/dikunin/.nvm/versions/node/v4.2.3/lib/node_modules/wakacli
TIMER=$($NODE $WAKACLI --nospinner)
TIMERCUT=${TIMER:8}
echo $TIMERCUT
