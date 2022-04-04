# icinga2-dockerized

##Container setup

### Database
Der DB Container können wir als fertiges Image direkt per `run` starten. Das Komando kann so genutzt werden. Benutzer und Passwort sollten dann allerdings angepasst werden.

```
$ docker run --detach --name mariadb \
--env MARIADB_USER=icinga \
--env MARIADB_PASSWORD=password \
--env MARIADB_ROOT_PASSWORD=root  \
-p 3306:3306 \
mariadb:latest
```

### Monitoring
Den Container für das Monitoring Tool bauen wir selber. Und können ihn einfach starten. 

```
$ docker run --link mariadb -it --rm --entrypoint /bin/bash  icinga2
root@d951282063d1:/# mysql -hmariadb -uicinga2 -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.5.5-10.7.3-MariaDB-1:10.7.3+maria~focal mariadb.org binary distribution

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 

```