#!/usr/bin/env bash

echo "Executing the setup script now."
su - ${DB2INSTANCE} -c "db2 create database ${DBNAME} automatic storage yes alias ${DBNAME} using codeset utf-8 territory us collate using system PAGESIZE 32768;"
su - ${DB2INSTANCE} -c "db2 connect to ${DBNAME}; db2 update database configuration for ${DBNAME} using LOGFILSIZ 2048;"

echo "Adding user add now."
useradd -m -s /bin/bash -d /database/config/${DBNAME} ${USERID}
echo ${USERPASS} | passwd ${USERID} --stdin

su - ${DB2INSTANCE} -c "db2 connect to ${DBNAME}; db2 create schema ${USERSCHEMA} AUTHORIZATION ${USERID} CREATE TABLE test \(source int, cost int, part_number int\); db2 GRANT CONNECT ON DATABASE TO USER ${USERID};"

echo "Success"