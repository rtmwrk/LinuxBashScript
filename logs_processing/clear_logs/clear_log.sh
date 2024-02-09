#!/bin/sh

#---------------------------------------------------------------------------------
# Скрипт очищает журналы приложений по правилам:
# 1. Старше DayOff дней - для приложений, которые отслеживаются службой "journald". 
# 2. Более DayOff дней не модифицировались - для всех остальных приложений. 
# 3. Для журналов более MaxFileSize - удаляются наиболее старые записи.
# Журналы отрабатываются в каталогах - /var/log и /run/log
#---------------------------------------------------------------------------------

# --- Устанавливаем константы ---
# Максимально допустимое время жизни журнала
DayOff=7d
# Максимально допустимый размер журнала для службы 'journald'
MaxFileSizeJournalD=50K
# Максимально допустимый размер журнала для утилиты 'find'
MaxFileSizeFind=50k
# Каталоги, в которых происходит очищение журналов
PathVarLog="/var/log/"
PathRunLog="/run/log/"

# --- Исполняемая часть скрипта ---
# Выводим сообщение о начале отбработки
echo "clear_log: Событие: процесс очистки журналов приложений начат." > /dev/kmsg

# --- Отрабатываем журналы, которые отслеживаются слубой journald ---
echo "clear_log: 1 этап. Обработка журналов, которые отслеживаются службой 'journald'." > /dev/kmsg
# Удаляем журналы старше DayOff дней, которые отслеживает служба journald
journalctl --vacuum-time=$DayOff --quiet
echo "clear_log: - журналы, старше $DayOff удалены." > /dev/kmsg
# Удаляем "устаревшую" часть журналов больше MaxFileSizeJournalD байт, которые отслеживаются journald
journalctl --vacuum-size=$MaxFileSizeJournalD --quiet
echo "clear_log: - в журналах, размером более $MaxFileSizeJournalD, удалены наиболее старые записи." > /dev/kmsg

# --- Отрабатываем журналы приложений, которые не отслеживаются journald ---
echo "clear_log: 2 этап. Обработка журналов, которые не отслеживаются службой 'journald'." > /dev/kmsg
# Ищем файлы отдельных служб, размер которых более MaxFileSizeFind байт и которые не отрабатываются journald, удаляем
# Служба "dnf" не отслеживается 'journald' и имеет отдельное поведение, поэтому удаляем скриптом
find $PathVarLog* -type f -name "dnf*" -size +$MaxFileSizeFind -exec rm {} \;
find $PathVarLog* -type f -name "hawkey*" -size +$MaxFileSizeFind -exec rm {} \;
find $PathRunLog* -type f -name "dnf*" -size +$MaxFileSizeFind -exec rm {} \;
find $PathRunLog* -type f -name "hawkey*" -size +$MaxFileSizeFind -exec rm {} \;
echo "clear_log: - журналы службы 'dnf' размером более $MaxFileSizeFind удалены." > /dev/kmsg

# Ищем файлы, которые более DayOff дней не модифицировались и удаляем
# Некоторые службы не добавляют к имени журнала расширение "log", поэтому удаляем все файлы
find $PathVarLog* -type f -mtime +${DayOff::-1} -exec rm {} \;
find $PathRunLog* -type f -mtime +${DayOff::-1} -exec rm {} \;
echo "clear_log: - журналы других служб, старше $DayOff удалены." > /dev/kmsg

# Выводим сообщение о завершении отбработки
echo "clear_log: Процесс очистки журналов приложений успешно завершен." > /dev/kmsg
