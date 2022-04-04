#!/bin/bash
set -e

red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
reset=`tput sgr0`


#set mysql
mysql -hmariadb -uroot -proot -e "CREATE DATABASE icinga2;"
mysql -hmariadb -uroot -proot -e "grant all privileges on icinga2.* to 'icinga2' identified by 'password';"

echo "${green}### CHECK_DB_ACCESS ###${reset}"
mysql -hmariadb -uicinga2 -ppassword -e "use icinga2" 2>/dev/null
if [ $? -eq 0 ];then
  echo "${blue}access to DB is working${reset}"
else
  echo "${red}access to DB is not working${reset}" && exit 127
fi


#start icinga
/etc/init.d/icinga2 start