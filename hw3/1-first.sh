#!/usr/bin/env bash


while true; do
read -p "Введите имя пользователя: " username
user_info=$(grep "^$username:" /etc/passwd)
if [ -z "$user_info" ]; then
    echo "Пользователь с именем $username не найден."
else
    break
fi
done

shell=$(echo "$user_info" | awk -F: '{print $7}')
home_directory=$(echo "$user_info" | awk -F: '{print $6}')
groups=$(id -nG "$username" | tr ' ' ',')

echo "$user_info"
echo "Шелл пользователя: $shell"
echo "Домашняя директория пользователя: $home_directory"
echo "Список групп, в которых состоит пользователь: $groups"

# Массив uid-ов
declare -a uid_list

# Функция для проверки совпадения uid
check_uid(){
  while IFS=: read -r _ _ uid _; do
    uid_list+=("$uid")
  done < /etc/passwd

  for i in "${uid_list[@]}"; do
    if [[ $i = $1 ]]; then
      return 0
    fi
  done
  return 1
}

# Что изменить
printf "Что следует поменять:\nuid (uid);\nдомашнюю директорию (dir);\nгруппу (group)\n"
read change_option
case $change_option in
    uid)
        read -p "Введите новый UID: " new_uid
	if check_uid "$new_uid"; then
          read -p "UID $new_uid уже занят. Попробуйте другой: " new_uid
	fi
        if check_uid "$new_uid"; then
	  printf "UID $new_uid уже занят.\nError: exit code 1\n" &&  exit 1
        fi
	command="sudo usermod -u $new_uid $username"
        ;;
    dir)
        read -p "Введите новую домашнюю директорию: " new_home_directory
        read -p "Переместить домашнюю директорию (y/n): " move_home
        command="sudo usermod -d $new_home_directory"
        [[ "$move_home" == "y" ]] && command+=" -m"
        command+=" $username"
        ;;
    group)
        read -p "Меняем основную группу или дополнительную (primary/additional): " group_option
        if [[ "$group_option" == "primary" ]]; then
            read -p "Введите новую основную группу: " new_primary_group
            command="sudo usermod -g $new_primary_group $username"
        elif [ "$group_option" == "additional" ]; then
            read -p "Введите новую дополнительную группу: " new_additional_group
            command="sudo usermod -aG $new_additional_group $username"
        else
            printf "Некорректный выбор.\nError: exit code 1\n"
            exit 1
        fi
        ;;
    *)
        printf "Некорректный выбор.\nError: exit code 1\n"
        exit 1
        ;;
esac

echo "Итоговая команда: $command"

