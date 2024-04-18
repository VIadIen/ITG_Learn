#!/usr/bin/env bash


read -p "Введите название дирректории " dir_name
mkdir $dir_name > /dev/null
echo "Директория $dir_name создана"

printf "Введите права доступа для данной директории в формате <цифра1><цифра2><цифра2>\n"
read mod
chmod $mod $dir_name
echo "Права доступа изменены" && ls -l | grep $dir_name
