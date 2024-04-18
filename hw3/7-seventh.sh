#!/usr/bin/env bash

# Функция для записи в лог
log() {
    local message=$1
    echo "$(date +"%d-%m-%Y %H:%M:%S") myDiskChecker: $message" >> disk_checker.log
}

# Проверка свободного места на партиции
check_disk_space() {
    local partition=$1
    local free_space=$(df -h | grep "$partition" | awk '{print $5}' | tr -d '%')

    if [ "$free_space" -lt 50 ]; then
        log "$partition - less than 50%"
    elif [ "$free_space" -lt 10 ]; then
        log "$partition - less than 10%"
    fi
}

# Основная часть скрипта
# Укажите партиции, за которыми нужно следить
partitions="/dev/sda1 /dev/sdb1"

for partition in $partitions; do
    check_disk_space "$partition"
done

