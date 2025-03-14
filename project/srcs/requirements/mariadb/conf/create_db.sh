#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql

    # Инициализация базы данных MariaDB
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
fi

if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
    rm -f /tmp/create_db.sql
fi