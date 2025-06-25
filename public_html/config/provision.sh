#!/bin/sh
# This script checks if the container is started for the first time.
CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"

if [ ! -e /$CONTAINER_FIRST_STARTUP ]
then
    touch /$CONTAINER_FIRST_STARTUP
    # run script only at first start of the container
    echo "Creating databases...."
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS laptopdr_m230 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"

    echo "Preparing SQL file - replacing URLs...."
    # Replace laptop-direct.ro with dev.laptop.io
    #sed -i 's/laptop-direct\.ro/dev.laptop.io/g' /root/laptopdr_m230.sql

    # Replace https://dev.laptop.io with http://dev.laptop.io
    #sed -i 's/https:\/\/dev\.laptop\.io/http:\/\/dev.laptop.io/g' /root/laptopdr_m230.sql

    echo "Importing databases...."
    #smysql -u root laptopdr_m230 < /root/laptopdr_m230.sql

    mysql -u root -e "DROP USER 'laptopdr'@localhost;"
    mysql -u root -e "FLUSH PRIVILEGES;"

    echo "Creating users...."

    mysql -u root -e "CREATE USER 'laptopdr'@localhost IDENTIFIED BY 'radu1980';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON laptopdr_m230 . * TO 'laptopdr'@'localhost';"

    mysql -u root -e "FLUSH PRIVILEGES;"

    echo "!!! DONE !!!"
fi