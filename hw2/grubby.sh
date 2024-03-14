#!/usr/bin/env bash
printf 'Обновление пакетов\n...\n'
dnf update -y > /dev/null
printf 'Пакеты обновлены\n'
sleep 1
printf 'Проверка наличия grubby\n'
rpm -q grubby > /dev/null
	if [ $? -eq 1 ]; then
		dnf install grubby -y > /dev/null
	fi
sleep 1
printf 'Текущее ядро:'
grubby --default-kernel
printf 'Вы уверены, что хотите сменить ядро?\nВведите ответ: [y|n]\t'
read ans
	if [ "$ans" != "y" ]; then
		printf "Операция отменена.\n"
		exit 1
	fi
sleep 1
printf '\nНиже приведен список доступных для загрузки ядер\n'
grubby --info=ALL | grep -E 'index|kernel'
printf '\nПосле применения изменений ВМ будет перезагружена\nУкажите индекс ядра, кторое необходимо установить\n'
read idx
kernel=$(grubby --info=ALL | grep -A 1 "index=$idx" | grep -oP '\".*\"' | sed 's/"//g')
printf "\nВм перезагрузится через:\n"
for i in {5..1}; do
	printf "$i\n"
	sleep 1
done
grubby --set-default=$kernel && reboot

