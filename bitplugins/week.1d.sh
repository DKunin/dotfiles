#!/bin/bash

# WeekNumber
# BitBar plugin
#
# by Dkunin
#
# Displays weeknumber
PLAN=$(/Users/dikunin/Projects/work-calendar-exchange/calendar)
DISPLAY_DATE=$(date +%d\ %b\ \(W%V\))
# DATE=W$(date +%V)
# PDATE=W$(date +%V | awk '{print $1 - 1}')
echo $DISPLAY_DATE
echo "---"
echo $PLAN
