#!/usr/bin/env bash
echo 'Введите название диска'
read part
echo -e 'n\np\n\n\n\nt\n82\nw\n' | fdisk /dev/$part
mkswap /dev/$part'1' | echo -n $(grep -o -E 'UUID.*') >> /etc/fstab && echo ' none swap sw 0 0' >> /etc/fstab
mount -a
swapon -a
lsblk
echo 'Сервер будет перезагружен через 5 секунд'
sleep 5
reboot
