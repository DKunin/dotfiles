#!/bin/bash

# WeekNumber
# BitBar plugin
#
# by Dkunin
#
# Displays weeknumber
DISPLAY_DATE=$(date +%d\ %b\ \(W%V\))
DATE=W$(date +%V)
PDATE=W$(date +%V | awk '{print $1 - 1}')
echo $DISPLAY_DATE
echo "---"
/Users/dikunin/Projects/work-calendar/cli
echo "$DATE :"
echo "Open Advert | href=https://cf.avito.ru/display/GE/$DATE%3A+Advert"
echo "Open Billing | href=https://cf.avito.ru/display/GE/$DATE%3A+Billing"
echo "Open CRM | href=https://cf.avito.ru/display/GE/$DATE%3A+CRM"
echo "Open Week | href=https://cf.avito.ru/display/GE/$DATE"
echo "$PDATE :"
echo "Open Advert ($PDATE) | color=gray href=https://cf.avito.ru/display/GE/$PDATE%3A+Advert"
echo "Open Billing ($PDATE) | color=gray href=https://cf.avito.ru/display/GE/$PDATE%3A+Billing"
echo "Open CRM ($PDATE) | color=gray href=https://cf.avito.ru/display/GE/$PDATE%3A+CRM"
echo "Open Week ($PDATE) | color=gray href=https://cf.avito.ru/display/GE/$PDATE"
