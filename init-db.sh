#!/bin/bash
docker exec mariadb mysql -e "create database keystone;"
docker exec mariadb mysql -e "GRANT ALL ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'password';"
docker exec mariadb mysql -e "GRANT ALL ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'password';"
docker exec mariadb mysql -e "flush privileges;"

