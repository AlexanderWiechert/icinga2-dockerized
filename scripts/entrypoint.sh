#!/bin/bash
set -e

red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`

#start icinga
/etc/init.d/icinga2 start

echo "${green}### Set Mysql Acccess ###${reset}"

#disable after devloping
mysql -hmariadb -uroot -proot -e "drop database icinga2"

mysql -hmariadb -uroot -proot -e "CREATE DATABASE IF NOT EXISTS icinga2;"
mysql -hmariadb -uroot -proot -e "CREATE DATABASE IF NOT EXISTS icingaweb2;"

mysql -hmariadb -uroot -proot -e "grant all privileges on icinga2.* to 'icinga2' identified by 'password';"
mysql -hmariadb -uroot -proot -e "grant all privileges on icingaweb2.* to 'icingaweb2' identified by 'password';"

echo "${green}### CHECK_DB_ACCESS ###${reset}"
mysql -hmariadb -uicinga2 -ppassword -e "use icinga2" 2>/dev/null
if [ $? -eq 0 ];then
  echo "${blue}successfully create access to DB${reset}"
  echo -e "\n"
else
  echo "${red}could not create access to DB${reset}" && exit 127
fi

echo "${green}### Import IDO schema ###${reset}"
mysql -hmariadb -uroot -proot icinga2 < /usr/share/icinga2-ido-mysql/schema/mysql.sql
if [ $? -eq 0 ];then
  echo "${blue}successfully import IDO schema${reset}"
  echo -e "\n"
else
  echo "${red}could not import IDO schema${reset}" && exit 127
fi

echo "${green}### Enable IDO schema ###${reset}"
icinga2 feature enable ido-mysql
if [ $? -eq 0 ];then
  echo "${blue}successfully enable IDO settings${reset}"
  echo -e "\n"
else
  echo "${red}could not enable IDO settings{reset}" && exit 127
fi

echo "${green}### Enable icinga db ###${reset}"
icinga2 feature enable icingadb
if [ $? -eq 0 ];then
  echo "${blue}successfully enable db${reset}"
  echo -e "\n"
else
  echo "${red}could not enable db${reset}" && exit 127
fi

echo "${green}### Enable icinga setup token ###${reset}"
icingacli setup config directory --group icingaweb2
SETUP_TOKEN=$(icingacli setup token create|awk {'print $NF'})
if [ $? -eq 0 ];then
  echo "${blue}successfully enable setup token ${reset}"
  echo -e "\n"
else
  echo "${red}could not setup token${reset}" && exit 127
fi

echo "${green}### Enable icinga api ###${reset}"
icinga2 api setup
if [ $? -eq 0 ];then
  TOKEN=$(cat /etc/icinga2/conf.d/api-users.conf |grep password |awk {'print $3'} |cut -d '"' -f2)
  echo "${blue}successfully enable api${reset}"
  echo -e "\n"
else
  echo "${red}could not enable api${reset}" && exit 127
fi

echo "${green}### Overview of important outputs: ###${reset}"
echo "Please note them for further setup"
echo -e "\n"
echo "${blue}icinga api token: ${red}$TOKEN ${reset}"
echo "${blue}icinga setup token: ${red}$SETUP_TOKEN ${reset}"
echo -e "\n"

#final restart of icinga service
/etc/init.d/icinga2 restart && /etc/init.d/apache2 start