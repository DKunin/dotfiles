#!/bin/bash

# Wakatime
# BitBar plugin
#
# by Dkunin
#
# Displays time of waka
NODE=/Users/dikunin/.nvm/versions/node/v7.0.0/bin/node
WAKACLI=/Users/dikunin/.nvm/versions/node/v7.0.0/lib/node_modules/wakacli
TIMER=$($NODE $WAKACLI --nospinner)
TIMERCUT=${TIMER:8}
echo $TIMERCUT
echo "---"
echo 'Dashboard | href=https://wakatime.com/dashboard' 
