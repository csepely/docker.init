#!/bin/bash

# services order
services+=(mysql)

p_start[mysql]="/etc/init.d/mysql start"
p_pid[mysql]="/etc/init.d/mysql stop"

# functions
function create_mysql_config {
  sed -i 's/^bind-address/#bind-address/' /etc/mysql/mariadb.conf.d/50-server.cnf
  grep -q '^innodb_log_file_size' /etc/mysql/mariadb.conf.d/50-server.cnf && sed -i 's/^innodb_log_file_size/innodb_log_file_size = 64M/' || echo "innodb_log_file_size = 64M" >> /etc/mysql/mariadb.conf.d/50-server.cnf
}

function secure_mysql {
  mysql_pass=$(apg -a 1 -n 1 -m 8 -x 8 -M Ncl -d)
  echo ":: Setting root password! ($mysql_pass)"
  printf -v update_root_pass "UPDATE mysql.user SET Password=PASSWORD('%s') WHERE User='root';FLUSH PRIVILEGES;DELETE FROM mysql.user WHERE User='';DROP DATABASE IF EXISTS test;DELETE FROM mysql.db WHERE Db='test' OR Db='test\\\\\\_%%';" "${mysql_pass}"
  mysql -B -u root --password='' -e "${update_root_pass}"
  printf -v add_remote_root "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%%' IDENTIFIED BY '%s'" "${mysql_pass}"
  mysql -B -u root --password='' -e "${add_remote_root}"
}

function execute_sql {
  if [[ -e /tmp/run.sql ]]
  then
    echo ":: Executing /tmp/run.sql ..."
    mysql -u root --password='' < /tmp/run.sql
  fi
}

before_service_start_hooks+=("create_mysql_config")
after_service_start_hooks+=("secure_mysql")
after_service_start_hooks+=("execute_sql")
