#! /bin/bash

#--------------------------------------------
# bh_stress: script creates a load CPU/Mem PC
# used for stress testing "Blockhost-Network"
#--------------------------------------------

#--------------------------------------------
# Atattion!
# For the  script  to  work successfully, you 
# must first  install the  stress-ng utility:
# dnf install stress-ng
#--------------------------------------------

#--- Выводим баннер скрипта ---
echo "-------------------------------------------"
echo "bh_stress: script creates a load CPU/Mem PC"
echo "used for stress testing 'Blockhost-Network'"
echo "-------------------------------------------"

#--- Инициализируем переменные ---
nameTmpFile=""

#--- Инициализируем константы ---
stressPrmCPU="-q --cpu 4 --io 10 --vm 2 --vm-bytes 2G --timeout 1d"
# Utility emulate:
# - 4 CPU
# - 10 pipe io
# - 2 vm pipe
# - 2G size each vm pipe

#--- Запускаем скрипт дополнительной нагрузки CPU/Mem ---
echo "[$(date)] Stress testing script has been launched"
echo -n "- additional load process has started"
stress-ng $stressPrmCPU &
echo " - ok"

echo "- the process of modifying temporary files has started - ok"
#--- Работаем до нажатия любой клавиши ---
while true;
do
    read -n 1 -s -r -t 0.001 key
    if [ $? = 0 ]
    then
      break
    fi

    #--- Иммитируем создание/открытие/редактирование/удаление файлов ---
    # Генерируем случайное имя файла ---
    nameTmpFile="tmp_$(uuidgen).txt"
    # Создаем пустой файл ---
    echo -ne "---- $nameTmpFile"
    # Заполняем файл случаййной последовательностью символов в 1 МБ ---
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 100 | head -n 100 > $nameTmpFile
    # Открываем/закрываем файл в текстовом редакторе ---
    cat $nameTmpFile > /dev/null
    # Удаляем тестовый файл
    rm -f $nameTmpFile
    echo -ne " - ok\r"
done
echo

#--- Завершаем скрипт дополнительной нагрузки CPU/Mem ---
killall -q stress-ng
rm -f "tmp*.txt"

echo "[$(date)] Stress testing script completed successfully"
# --- Формируем код возврата "Ок" ---
exit 0