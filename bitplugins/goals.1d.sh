#!/bin/bash

# Wegoal
# BitBar plugin
#
# by Dkunin
#
# Displays weekly Goals

goals=( "✅ Запустить обновление версии" "🕰️ Запустить маркетинг про обновление")
len=${#goals[@]}

echo "Цели 1/${len}";
echo "---";
for i in "${goals[@]}"
do
	echo "$i"
done
# echo "Раскатить АБ мессенджера на 100%";
# echo "Запустить АБ поиска и рекомендацишй";
