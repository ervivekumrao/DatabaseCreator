sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'clr enabled', 1;
GO
RECONFIGURE;
GO
sp_configure 'clr strict security', 0;
GO
RECONFIGURE;
GO
CREATE DATABASE mssqldb
ON
(   Name = mssqldb_data,
    FILENAME = '/var/opt/mssql/data/mssqldb.mdf',
    SIZE = 1024MB,
    FILEGROWTH = 64MB )
LOG ON
(   NAME = mssqldb_log,
    FILENAME = '/var/opt/mssql/data/mssqldb_log.ldf',
    SIZE = 64MB,
    FILEGROWTH = 8MB ) ;
GO
USE mssqldb;
GO
create login userid with password = 'userpass', DEFAULT_DATABASE = mssqldb, check_policy = off;
GO
create user userid for login userid;
GO
CREATE SCHEMA userdata AUTHORIZATION userid
    CREATE TABLE test (source int, cost int, part_number int)
GO