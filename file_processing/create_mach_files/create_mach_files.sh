#! /bin/sh

#---------------------------------------------------------------------
# Параметры:
# @amountFiles - количество создаваемых файлов
# @nameFiles   - схема наимонования создаваемых файлов
# @pathFiles   - каталог, в котором создаются файлы
# @testSequence- тестовая последовательность символов
#---------------------------------------------------------------------

# --- Инициализируем константы ---
amountFiles=100
nameFiles="test"
pathFiles="/media/hdd/"
testSequence="qwerty1234"

# --- Функции ---
# Обработка ошибок
function printError {
  # Вывод сообщения об ошибке
  echo "[$(date)] Ошибка!. Входе выполнения операции произошла ошибка. Выполнение скрипта прервано"
  exit -1
}

# --- Исполняемая часть ---
# Вывод сообщения о назначении скрипта
echo "------------------------------------------------------------------------------------"
echo "create_mach_files.sh: Создание заданного количества файлов с тестовой последовательностью"
echo "------------------------------------------------------------------------------------"

# Вывод сообщения о начале работы скрипта
echo "[$(date)] Процесс создания файлов начат"

# Создание файлов
for ((i=1; i<=amountFiles; i++))
do
  cd "$pathFiles"
  echo "$testSequence" > "$nameFiles$i.txt"
  echo -n -e "- создаю файл $nameFiles$i.txt\r"
done
echo

# Вывод сообщения о завершении работы скрипта
echo "[$(date)] Процесс создания файлов успешно завершен"
