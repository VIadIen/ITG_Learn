#!/usr/bin/env bash

# Проверка примонтировано ли устройство и передан ли путь к файлу
if [[ $# -eq 0  ]]; then
  echo "Путь к устройству не передан" && exit 1
elif [[ "$(cat /proc/mounts | grep -o "^$1 ")" ]]; then
  echo "Устройство $1 примонтировано"
  exit 90
# Монтирование устройства
elif [[ -e $1 ]]; then
  dir_name=$(mktemp -d)
  if mount "$1" "$dir_name" 2>/dev/null; then
  echo "Теперь устройство $1 примонтировано, смотри:" &&  cat /proc/mounts | grep "^$1 "
  exit 0
  fi
fi
echo "Error: возможно, это не блочное устройство"

