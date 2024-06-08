#!/bin/sh

echo "[info] Starting Mariadb"

MYSQLD_DIR=/run/mysqld
MYSQL_DIR=/var/lib/mysql
# MYSQL_DIR=/usr/local/mariadb

if [ ! -d $MYSQLD_DIR ]; then
    echo "[info] $MYSQLD_DIR not found, creating now"
    mkdir -p $MYSQLD_DIR
fi

if [ ! -d $MYSQL_DIR ]; then
    echo "[info] $MYSQL_DIR not found, creating now"
    mkdir -p $MYSQL_DIR
fi

# changing ownership of directories to mysql user and group
chown mysql:mysql $MYSQLD_DIR $MYSQL_DIR
echo "[info] Ownership of $MYSQL_DIR and $MYSQLD_DIR changed to mysql user and group"

# checking for data dir and then initializing mysql tables if not found
if [ ! -d $MYSQL_DIR/mysql ]; then
    echo "[info] MySQL data directory not found, creating new one and initializing system tables"
    if mysql_install_db --user=mysql --datadir=$MYSQL_DIR > /dev/null ; then
        echo "[info] MySQL data directory initialization was a success"
    else
        echo "[error] MySQL data directory initialization failed"
        return 1
    fi
fi

SQL_FILE=init.sql
echo "[info] Making $SQL_FILE"
cat << EOF > $SQL_FILE
-- flush privileges for root user
FLUSH PRIVILEGES;

-- remove any empty users
DELETE FROM mysql.user WHERE user='';

-- remove the test database
DROP DATABASE IF EXISTS test;

-- remove any entry related to test in db table
DELETE FROM mysql.db WHERE db='test';

-- restrict remote access to root
DELETE FROM mysql.user WHERE user='root' AND host NOT IN ('localhost', '127.0.0.1', '::1');

-- changing the root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';

-- make new database with env variable as name
CREATE DATABASE IF NOT EXISTS \`$MARIADB_DATABASE\`;

-- make new user with specific name and grant access from any host identified by set password
CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED by '$MARIADB_USER_PASSWORD';

-- grants all privileges on wordpress database to the user on any host
GRANT ALL PRIVILEGES ON \`$MARIADB_DATABASE\`.* TO '$MARIADB_USER'@'%';
FLUSH PRIVILEGES;
EOF

MYSQL_OPTIONS="--user=mysql --skip-name-resolve --skip-networking=0 --bind-address=0.0.0.0"

# Run the SQL daemon to create the database and user and run the daemon in bootstrap mode to init tables
mysqld $MYSQL_OPTIONS --bootstrap < $SQL_FILE
echo "[info] MySQLD databases are now initialized"

rm $SQL_FILE

# Run the SQL server in the foreground
echo "[info] MySQL server is now running..."
mysqld $MYSQL_OPTIONS --console
