#!/usr/bin/env bash


file="users.txt"

show_user_info() {
    local username=$1
    grep "^$username " "$file" | awk '{ print "User:", $1, "\nCreation Date:", strftime("%c", $2), "\nDeletion Date:", ($3 != "-") ? strftime("%c", $3) : "-", "\nHome Directory:", $4 }'
}


create_user() {
    local username=$1
    local home_dir=$2
    local creation_date=$(date +%s)
    echo "$username $creation_date - $home_dir" >> "$file"
}

delete_user() {
    local username=$1
    local deletion_date=$(date +%s)
    sed -i "s/^$username .*$/& $deletion_date/" "$file"
}

show_all_users() {
    awk '{ print NR ":", $1, strftime("%c", $2), ($3 != "-") ? strftime("%c", $3) : "-", $4 }' "$file"
}

# Проверка наличия файла с данными пользователей
if [ ! -f "$file" ]; then
    touch "$file"
fi

# Обработка аргументов скрипта с помощью getopts
while getopts ":s:c:d:h:a" opt; do
    case $opt in
        s)
            show_user_info "$OPTARG"
            ;;
        c)
            create_user "$OPTARG" "$OPTARG"
            ;;
        d)
            delete_user "$OPTARG"
            ;;
        a)
            show_all_users
            ;;
        h | *)
            echo "Использование: $0 {s|c|d|a} [username] [home_dir]"
            echo "s - вывод информации о пользователе"
            echo "c - добавление пользователя с указанным home_dir"
            echo "d - уволнение пользователя"
            echo "a - вывод списка всех пользователей"
            ;;
    esac
done

