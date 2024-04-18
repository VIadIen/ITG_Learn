#!/usr/bin/env bash

# Проверка количества аргументов
if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <входной_файл> <выходной_файл>"
    exit 1
fi

input_file=$1
output_file=$2

# Проверка существования входного файла
if [ ! -f "$input_file" ]; then
    echo "Входной файл не существует"
    exit 1
fi

# Проверка существования выходного файла
if [ -f "$output_file" ]; then
    echo "Выходной файл уже существует"
    exit 1
fi

# Считываем содержимое входного файла
lines=()
while IFS= read -r line; do
    lines+=("$line")
done < "$input_file"

# Поменяем местами четные и нечетные строки
for ((i = 1; i < ${#lines[@]}; i += 2)); do
    tmp=${lines[$i]}
    lines[$i]=${lines[$((i - 1))]}
    lines[$((i - 1))]=$tmp
done

# Записываем содержимое в выходной файл
for line in "${lines[@]}"; do
    echo "$line" >> "$output_file"
done

echo "Преобразование завершено. Результат записан в $output_file"

