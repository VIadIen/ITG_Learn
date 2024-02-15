mkfifo pipe
echo +%s > pipe & date $(cat pipe)
