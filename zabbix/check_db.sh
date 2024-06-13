# Имя контейнера Docker
Container=mysql-source
# Строка, которую нужно найти в логах
SEARCH_STRING="port: 3306  MySQL Community Server - GPL."
# Интервал проверки в секундах
CHECK_INTERVAL=3

# Функция для проверки логов Docker
check_docker_logs() {
	docker logs "$Container" 2>&1 | grep -q "$SEARCH_STRING"
    return $?
}

# Функция для обновления строки на экране
update_line() {
    local message="$1"
    echo -ne "\r\033[K$message"
}

# Функция для скрытия курсора
hide_cursor() {
#    echo -ne "\e[?25l"
    echo "\e[?25l"
}

# Функция для отображения курсора
show_cursor() {
    echo -ne "\e[?25h"
}

hide_cursor

i=""


# Основной цикл проверки
while true; do
    if check_docker_logs; then
        echo "СУБД инициализирована."
        break
    else
        update_line "Идёт инициализация СУБД$i"
        sleep $CHECK_INTERVAL
	i=$i".";
	if [ ${#i} -eq 4 ]; then
		i=""
	fi
    fi
done
# Перенос строки после завершения цикла
echo
