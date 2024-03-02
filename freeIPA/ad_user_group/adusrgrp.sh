#!/bin/sh

#------------------------------------------------
#
# Параметры:
# @amountRootGroups  - количество создаваемых корневых групп
# @amountLevelGroups - количество уровней вложенности
# @nameMainTester    - имя единого тестового пользователя
# @fileReport        - файл отчета о работе скрипта
# @prefNameUnit      - префикс группы/пользователя
#------------------------------------------------

# --- Инициализируем константы ------------------
amountRootGroups=10000
amountLevelGroups=3
nameMainTester="Grand"
fileReport="adusrgrp.log"
prefNameUnit="_lvl3_sub5_"

# --- Функции -----------------------------------
# Обработка ошибок
function printError {
  # Вывод сообщения об ошибке
  echo "[$(date)] Ошибка! В ходе выполнения последней операции произошла ошибка" | tee -a $fileReport
  echo "Для получения детальной информации обратитесь к файлу отчета - $fileReport" | tee -a $fileReport
  # Выполнение скрипта прерывается
  exit -1
}

# --- Исполняемая часть--------------------------
# Вывод сообщения о назначении скрипта
echo "------------------------------------------------------------------------------" | tee -a $fileReport
echo "adusrgrp.sh: Создание заданного количества пользователей/групп в Linux FreeIPA" | tee -a $fileReport
echo "------------------------------------------------------------------------------" | tee -a $fileReport

# Вывод сообщения о начале работы скрипта
echo "[$(date)] Процесс создания пользователей/групп начат" | tee -a $fileReport

# Создание единого пользователя
#ipa user-add $nameMainTester --first=Tester --last=$nameMainTester
#echo "[$(date)] Единый тестовый пользователь $nameMainTester создан" | tee -a $fileReport

# Создаем остальных пользователей/группы
for ((i=1; i<=$amountRootGroups; i++))
do
  # Создание корневой группы
  ipa group-add "g"$prefNameUnit$i"_1"
  echo "[$(date)] Корневая группа g"$prefNameUnit$i"_1 создана" >> $fileReport

  ipa user-add "u"$prefNameUnit$i"_1" --first=Tester --last=user
  echo "- пользователь u$prefNameUnit$i"_1" создан" >> $fileReport

  ipa group-add-member "g"$prefNameUnit$i"_1" --user="u"$prefNameUnit$i"_1"
  echo "- пользователь u$prefNameUnit$i"_1" добавлен в корневую группу" >> $fileReport

  #ipa group-add-member "g"$prefNameUnit$i"_1" --user=$nameMainTester
  #echo "- единый пользователь $nameMainTester добавлен в корневую группу" >> $fileReport

  # Создание вложенных пользователей/групп
  for ((j=2; j<=$amountLevelGroups; j++))
  do
    ipa group-add "g"$prefNameUnit$i"_"$j
    echo "- дочерняя группа g$prefNameUnit$i"_"$j создана" >> $fileReport

    ipa user-add "u"$prefNameUnit$i"_"$j --first=Tester --last=user
    echo "- пользователь u$prefNameUnit$i"_"$j создан" >> $fileReport

    ipa group-add-member "g"$prefNameUnit$i"_"$j --user="u"$prefNameUnit$i"_"$j
    echo "- пользователь u$prefNameUnit$i"_"$j добавлен в дочернюю группу g$prefNameUnit$i"_"$j" >> $fileReport

    #ipa group-add-member "g"$prefNameUnit$i"_"$j --user=$nameMainTester
    #echo "- единый пользователь $nameMainTester добавлен в дочернюю группу g$prefNameUnit$i"_"$j" >> $fileReport

    ipa group-add-member "g"$prefNameUnit$i"_"$(($j-1)) --group="g"$prefNameUnit$i"_"$j
    echo "- дочерняя группа g$prefNameUnit$i"_"$j добавлена в родительскую группу" >> $fileReport
  done
done

# Вывод сообщения о завершении скрипта
echo "[$(date)] Процесс создания пользователей/групп успешно завершен" | tee -a $fileReport
echo | tee -a $fileReport
