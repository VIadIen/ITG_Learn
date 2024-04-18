#!/usr/bin/env bash


# Функция для записи в лог
log() {
    local status=$1
    local PID=$2
    local service=$3
    echo "$(date +"%d-%m-%Y %H:%M:%S") mySvcChecker: service $service ($PID) $status" >> mySvcChecker.log
}

# Функция для проверки состояния сервиса
check_service() {
    local PID=$1
    local service=$(ps -p $PID -o comm=)
    while true; do
        # Проверяем, запущен ли сервис с указанным PID
        if ps -p "$PID" > /dev/null; then
            log "isUP" "$PID" "$service"
        else
            log "isDown" "$PID" "$service"
        fi
        sleep 30
    done
}

# Получаем аргументы командной строки
PID=$1

# Проверяем, является ли аргумент числом (PID) или строкой (именем сервиса)
if [[ "$PID" =~ ^[0-9]+$ ]]; then
    echo "это пид"
    check_service "$PID"
else
    echo "я зашел в елс"
    PID=$(pgrep "$PID")
    check_service "$PID"
fi

