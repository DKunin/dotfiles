#!/bin/bash

# WeekNumber
# BitBar plugin
#
# by Dkunin
#
# Displays weeknumber
DATE=W$(date +%V)
echo $DATE
echo "---"
echo "Open Advert | color=gray href=https://cf.avito.ru/display/GE/$DATE%3A+Advert"
echo "Open Billing | color=gray href=https://cf.avito.ru/display/GE/$DATE%3A+Billing"
echo "Open CRM | color=gray href=https://cf.avito.ru/display/GE/$DATE%3A+CRM"
echo "Open Week | color=gray href=https://cf.avito.ru/display/GE/$DATE"
