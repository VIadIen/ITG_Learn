#!/usr/bin/env bash
echo 'Введите название диска'
read part
sleep 1

#Create partition
echo -e "mklabel gpt\nmkpart primary xfs 0% 100%\nq" | parted /dev/$part > /dev/null

#Make xfs
echo 'Введите название директории'
read name_dir
        mkdir /$name_dir && mkfs.xfs /dev/$part'1'>/dev/null && mount /dev/$part'1' /$name_dir
        blkid -s UUID /dev/$part'1' | sed 's/"//g' | echo -n $(grep -o -E 'UUID.*[^\ ]') >> /etc/fstab && echo " /"$name_dir" deafults 0 0" >> /etc/fstab

#Get size tmpfs
echo 'Укажите размер ОЗУ'
read size
size=$(( $size/4 ))

#Mount tmpfs
        echo "tmpfs /$name_dir/tmpfs tmpfs size="$size"G 0 0" >> /etc/fstab
        systemctl daemon-reload
        mkdir /$name_dir/tmpfs && mount -t tmpfs /$name_dir/tmpfs > /dev/nul
#Chteck result
df -hT
echo ''
echo ''
lsblk
