#-------------------------------------------------------------
# bnh_rm: скрипт удаляет пакеты "Блокхость-Сети" с компьютера,
#         логи, временные директории
#-------------------------------------------------------------

#-------------------------------------------------------------
# Константы:
# @bhnDir - каталог 'Блокхост-Сети' на клиенте
# @bhnCache - каталог 'VMWare Workstation'
# @bnhLog - каталог журналов 'Блокхост-Сети'
#-------------------------------------------------------------

# --- Инициализируем константы ---
bhnDir="/opt/Blockhost"
bhnCache="/home/user/.cache/vmware/drag_and_drop"
bhnLog="/var/log/blockhost"
nameOS=""

# --- Функция обработки ошибок ---
function printError {
  echo "[$(date)] Ошибка! Удаление пакета 'Блокхост-Сеть' аварийно прервано"
  exit -1
}

# --- Функция определения имени ОС ---
function getNameOS {
  if [[ "$(hostnamectl | grep -ci 'Red OS')" -ne "0" ]]
  then
    # RED OS
    return 1
  elif [[ "$(hostnamectl | grep -ci 'Astra Linux')" -ne "0" ]]
  then
    # Astra Linux
    return 2
  elif [[ "$(hostnamectl | grep -ci 'Alt')" -ne "0" ]]
  then
    # Alt Linux
    return 3  
  else
    return 0
  fi
}

# --- Выводим баннер скрипта ---
echo "------------------------------------------------"
echo "bhn_rm.sh - удаление пакета 'Блокхост-Сеть' с РС"
echo "------------------------------------------------"

# --- Выводим сообщение о начале работы скрипта ---
echo "[$(date)] Процесс удаления 'Блокхост-Сеть' начат"

# --- Определяем имя ОС ---
echo -n -e "1. Определяю имя ОС клиента"
getNameOS
nameOS=$?
if [[ $nameOS -ne 0 ]]
then
  echo " - ok"
else
  echo " - error"
  printError
fi

# --- Деинсталлируем пакет ---
echo "2. Деинсталлирую пакет"
case $nameOS in
  1) dnf remove blockhost* -y || printError;;
  2) apt remove blockhost* -y || printError;;
  3) apt-get remove blockhost* -y || printError;;
esac

# --- Удаляем остатки каталога "Blockhost" ---
echo -n -e "3. Очищаю настройки"
if [[ -d "$bhnDir" ]]
then
  rm -r "$bhnDir" || printError
fi
echo " - ok"

# --- Удаляем кэш "VMWare" ---
echo -n -e "4. Очищаю кэш VMWare "
rm -rf $bhnCache"/"*
echo "- ok"

# --- Удаляем логи "Блокхост-Сети" ---
echo -n -e "5. Очищаю журналы "
rm -rf $bhnLog*
echo "- ok"

# --- Выводим сообщение о завершении работы скрипта ---
echo "[$(date)] Процесс удаления 'Блокхост-Сеть' успешно завершен"