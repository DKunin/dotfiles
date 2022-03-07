#!/bin/bash

# Wegoal
# BitBar plugin
#
# by Dkunin
#
# Displays weekly Goals

goals=( "✅ Запустить обновление версии" "✅  Запустить маркетинг про обновление")
nextgoals=( "Раскатить жесткое обновление" "Раскатить АБ мессенджера на 100%" "Запустить АБ поиска и рекомендацишй")
len=${#goals[@]}

echo "Цели 2/${len}";
echo "---";
for i in "${goals[@]}"
do
	echo "$i"
done
# echo "---";
# echo "";
# echo "*Сегодня:*";
# echo "Встречи:";
# echo "";
# # $PROJECTS/work-calendar-exchange/calendar;
# echo "";
# echo "Задачи:";
# echo "";
# whats-my-tech-lead-up-to;

echo "---";
for i in "${nextgoals[@]}"
do
	echo "$i"
done


