#!/usr/bin/env bash

# Функция для записи в лог
log() {
    local message=$1
    echo "$(date +"%d-%m-%Y %H:%M:%S") myHostChecker: $message" >> host_checker.log
}

# Проверка доступности IP-адреса
check_host() {
    local ip=$1
    local count=3

    if ping -c $count $ip > /dev/null 2>&1; then
        log "$ip - UP"
    else
        log "$ip - DOWN"
    fi
}

# Основная часть скрипта
# Проверяем, передан ли аргумент
if [ -z "$1" ]; then
    echo "Укажите IP-адрес в качестве аргумента"
    exit 1
fi

# Проверяем доступность IP-адреса
check_host "$1"

