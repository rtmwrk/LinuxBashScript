#!/bin/sh

#---------------------------------------------------------------------------------
# add_env_for_astra_1_7 - скрипт установки программного комплекса "Блокхост-Сеть"
# и дополнительных библиотек разработчика 
#---------------------------------------------------------------------------------

# --- Функции --------------------------------------------------------------------
# Обработка ошибок
function printError {
  # Вывод сообщения об ошибке
  echo "[$(date)] Ошибка! В ходе выполнения последней операции произошла ошибка"
  echo "Выполнение скрипта прервано" 
  # Выполнение скрипта прерывается
  exit -1
}

# --- Исполняемая часть-----------------------------------------------------------
# Вывод сообщения о назначении скрипта
echo "--------------------------------------------------------------------------" 
echo "add_env_for_astra_1_7.sh: Установка программного комплекса 'Блокхост-Сеть'" 
echo "--------------------------------------------------------------------------" 

# Вывод сообщения о начале работы скрипта
echo "[$(date)] Процесс установки программного комплекса 'Блокхост-Сеть' начат"

# Создание служебных каталогов, установка требуемых прав
mkdir /var/log/BlockHost || printError
mkdir -p /opt/Blockhost/client/log || printError
mkdir -p /opt/Blockhost/console/log || printError
chmod 777 /opt/Blockhost/console/log || printError
chmod 777 /opt/Blockhost/client/log || printError
chmod 777 /var/log/BlockHost || printError
echo "- создаю служебные каталоги комплекса 'Блокхост-Сеть'"

# Создание ссылок
ln -s /mnt/hgfs/test/ /home/user/Desktop/test || printError
ln -s /opt/Blockhost/console/ /home/user/Desktop/console || printError
echo "- создаю ссылки комплекса 'Блокхост-Сеть'"

# Непосредственно установка "Блокхост-Сеть"
cd "/mnt/hgfs/test/_install/install/" || printError
apt-get -y install ./$(ls *client*astralinux_1.7*.deb) || printError
apt-get -y install ./$(ls *server*astralinux_1.7*.deb) || printError
apt-get -y install ./$(ls *console*astralinux_1.7*.deb) || printError
echo "- устанавливаю программные пакеты 'Блокхост-Сеть'"

# Установка дополнительных пакетов разработчика
apt-get -y install python || printError
apt-get -y install python-setuptools || printError
apt-get -y install gcc-8-base || printError
apt-get -y install python-six || printError
python /home/user/Desktop/test/req/get-pip-2.7.py || printError
python /usr/local/bin/pip install impacket || printError
echo "- устанавливаю дополнительные пакеты разработчика"

# Отключение службы "avahi-daemon"
systemctl disable avahi-daemon.socket || printError
systemctl disable avahi-daemon.service || printError
systemctl stop avahi-daemon.socket || printError
systemctl stop avahi-daemon.service || printError
echo "- отключаю службу 'avahi-demon'"

# Изменение настроек сетевого интерфейса
nmcli device modify eth1 ipv4.dns 172.168.0.8 || printError
systemctl restart NetworkManager || printError
echo "- изменяю настройки сетевого интерфейса"

# Вывод сообщения о завершении скрипта
echo "[$(date)] Процесс установки программного комплекса 'Блокхост-Сеть' успешно завершен"
