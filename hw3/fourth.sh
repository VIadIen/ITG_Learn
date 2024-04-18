#!/usr/bin/env bash


# Создаем файл со списком пользователей
awk -F: '{print $1}' /etc/passwd > users.txt

# Выводим содержимое файла с нумерацией строк
i=0
echo "Содержимое файла users.txt с нумерацией строк:"
for line in $(cat users.txt); do
    echo "$((i++)). $line"
done

# Альтернативный вариант
read -p "Показать альтернативный вариант? [y/n] " ans
if [[ $ans == "y" ]]; then
  for line in $(cat users.txt); do
      echo "$line"
  done | nl
fi
