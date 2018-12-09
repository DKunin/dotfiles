#!/bin/bash

# WeekNumber
# BitBar plugin
#
# by Dkunin
#
# Displays weeknumber
# PLAN=$(/Users/dikunin/Projects/work-calendar-exchange/calendar)
# DATE=W$(date +%V)
# PDATE=W$(date +%V | awk '{print $1 - 1}')
echo $(date +%d\ %b\ \(W%V\))
# echo "---"
# echo $PLAN
