# Database Engine & Connection Reference Guide

**SPDX-License-Identifier:** Apache-2.0  
**Copyright:** (c) 2024-2026 Vivek Umrao and DatabaseCreator contributors.

---

This guide provides technical specifications, connection URLs, CLI connection commands, and code samples for all **12 database, cache, and lakehouse engines** supported by DatabaseCreator.

---

## 1. MySQL

- **Engine Key:** `-t mysql`
- **Default Port:** `3306`
- **Default Database:** `userdata` | **User:** `userid` | **Password:** `P@55w0rd`
- **Root User:** `root` | **Root Password:** `P@55w0rd`
- **Driver Class:** `com.mysql.cj.jdbc.Driver`
- **JDBC URL:** `jdbc:mysql://localhost:3306/userdata?allowPublicKeyRetrieval=true&useSSL=false`
- **CLI Connection:**
  ```bash
  mysql -h 127.0.0.1 -P 3306 -u userid -p'P@55w0rd' userdata
  ```
- **Python (PyMySQL):**
  ```python
  import pymysql
  conn = pymysql.connect(host='127.0.0.1', port=3306, user='userid', password='P@55w0rd', database='userdata')
  ```

---

## 2. MariaDB

- **Engine Key:** `-t mariadb`
- **Default Port:** `3306`
- **Default Database:** `userdata` | **User:** `userid` | **Password:** `P@55w0rd`
- **Driver Class:** `org.mariadb.jdbc.Driver`
- **JDBC URL:** `jdbc:mariadb://localhost:3306/userdata`
- **CLI Connection:**
  ```bash
  mariadb -h 127.0.0.1 -P 3306 -u userid -p'P@55w0rd' userdata
  ```

---

## 3. PostgreSQL

- **Engine Key:** `-t postgres` or `-t postgresql`
- **Default Port:** `5432`
- **Default Database:** `pgdb` | **User:** `userid` | **Password:** `P@55w0rd`
- **Default Schema:** `userdata`
- **Driver Class:** `org.postgresql.Driver`
- **JDBC URL:** `jdbc:postgresql://localhost:5432/pgdb`
- **CLI Connection:**
  ```bash
  PGPASSWORD='P@55w0rd' psql -h localhost -p 5432 -U userid -d pgdb
  ```
- **Python (psycopg2):**
  ```python
  import psycopg2
  conn = psycopg2.connect("host=localhost port=5432 dbname=pgdb user=userid password=P@55w0rd")
  ```

---

## 4. Microsoft SQL Server (MSSQL)

- **Engine Key:** `-t mssql` or `-t "sql server"`
- **Default Port:** `1433`
- **Default Database:** `mssql` | **User:** `userid` | **Password:** `P@55w0rd`
- **Admin User:** `sa` | **Password:** `P@55w0rd`
- **Default Schema:** `userdata`
- **Driver Class:** `com.microsoft.sqlserver.jdbc.SQLServerDriver`
- **JDBC URL:** `jdbc:sqlserver://localhost:1433;databaseName=mssql;selectMethod=cursor;trustServerCertificate=true;`
- **CLI Connection:**
  ```bash
  sqlcmd -S localhost,1433 -U sa -P 'P@55w0rd' -C -Q "SELECT @@VERSION"
  ```

---

## 5. Oracle Autonomous Database Free / XE

- **Engine Key:** `-t oracle`
- **Default Port:** `1521`
- **Default Database:** `oracledb` | **User:** `userid` | **Password:** `0raclePa55w0rd`
- **Admin User:** `admin` | **Password:** `0raclePa55w0rd`
- **Driver Class:** `oracle.jdbc.OracleDriver`
- **JDBC URL:** `jdbc:oracle:thin:@//localhost:1521/oracledb`
- **CLI Connection:**
  ```bash
  sqlplus admin/"0raclePa55w0rd"@localhost:1521/oracledb
  ```

---

## 6. IBM DB2 Community Edition

- **Engine Key:** `-t db2`
- **Default Port:** `50000`
- **Default Database:** `ibmdb` | **Instance:** `db2inst` | **Password:** `P@55w0rd`
- **User:** `userid` | **Password:** `P@55w0rd`
- **Driver Class:** `com.ibm.db2.jcc.DB2Driver`
- **JDBC URL:** `jdbc:db2://localhost:50000/ibmdb:progressiveLocators=2;`
- **CLI Connection (inside container):**
  ```bash
  podman exec -it localdb su - db2inst -c "db2 connect to ibmdb; db2 'SELECT * FROM userdata.test'"
  ```

---

## 7. MongoDB

- **Engine Key:** `-t mongodb`
- **Default Port:** `27017`
- **Default Database:** `mgdb` | **User:** `userid` | **Password:** `P@55w0rd`
- **Driver Class:** `mongodb.jdbc.MongoDriver`
- **Connection URI:** `mongodb://userid:P%4055w0rd@localhost:27017/mgdb?authSource=admin`
- **CLI Connection:**
  ```bash
  mongosh "mongodb://userid:P%4055w0rd@localhost:27017/mgdb?authSource=admin"
  ```
- **Python (pymongo):**
  ```python
  from pymongo import MongoClient
  client = MongoClient("mongodb://userid:P%4055w0rd@localhost:27017/mgdb?authSource=admin")
  db = client.mgdb
  ```

---

## 8. Redis / Valkey

- **Engine Key:** `-t redis` or `-t valkey`
- **Default Port:** `6379`
- **Password:** `P@55w0rd`
- **Connection URI:** `redis://:P@55w0rd@localhost:6379/0`
- **CLI Connection:**
  ```bash
  redis-cli -h localhost -p 6379 -a 'P@55w0rd' PING
  ```
- **Python (redis-py):**
  ```python
  import redis
  r = redis.Redis(host='localhost', port=6379, password='P@55w0rd')
  r.set('key', 'value')
  ```

---

## 9. ClickHouse Columnar Analytics

- **Engine Key:** `-t clickhouse`
- **HTTP Port:** `8123` | **Native Port:** `9000`
- **Default Database:** `userdata` | **User:** `userid` | **Password:** `P@55w0rd`
- **Driver Class:** `com.clickhouse.jdbc.ClickHouseDriver`
- **JDBC URL:** `jdbc:ch://localhost:8123/userdata`
- **CLI Connection (HTTP / curl):**
  ```bash
  curl -u 'userid:P@55w0rd' 'http://localhost:8123/?query=SELECT%201'
  ```
- **Python (clickhouse-connect):**
  ```python
  import clickhouse_connect
  client = clickhouse_connect.get_client(host='localhost', port=8123, username='userid', password='P@55w0rd', database='userdata')
  ```

---

## 10. CockroachDB Distributed SQL

- **Engine Key:** `-t cockroach` or `-t cockroachdb`
- **SQL Port:** `26257` | **Web Console Port:** `8080`
- **Default Database:** `userdata` | **User:** `userid` | **Password:** `P@55w0rd`
- **Driver Class:** `org.postgresql.Driver`
- **JDBC URL:** `jdbc:postgresql://localhost:26257/userdata?sslmode=disable`
- **CLI Connection (via psql or cockroach sql):**
  ```bash
  psql -h localhost -p 26257 -U userid -d userdata
  ```
- **Web Admin Dashboard:**
  Open browser at `http://localhost:8080` to inspect node metrics, query performance, and active sessions.

---

## 11. Snowflake Local Emulator

- **Engine Key:** `-t snowflake` or `-t snowflake-emulator`
- **Port:** `8080`
- **Default Database:** `USERDATA` | **Schema:** `PUBLIC` | **Warehouse:** `COMPUTE_WH`
- **User:** `userid` | **Password:** `P@55w0rd`
- **Driver Class:** `net.snowflake.client.jdbc.SnowflakeDriver`
- **JDBC URL:** `jdbc:snowflake://localhost:8080/?db=USERDATA&schema=PUBLIC&warehouse=COMPUTE_WH&ssl=off`
- **Python (snowflake-connector-python):**
  ```python
  import snowflake.connector
  ctx = snowflake.connector.connect(
      user='userid',
      password='P@55w0rd',
      account='local',
      host='localhost',
      port=8080,
      protocol='http',
      database='USERDATA',
      schema='PUBLIC'
  )
  ```

---

## 12. Databricks Local Lakehouse (Apache Spark + Delta Lake)

- **Engine Key:** `-t databricks` or `-t spark-delta`
- **Thrift JDBC Port:** `10000` | **Spark Web UI:** `4040`
- **Default Database:** `userdata` | **Storage Format:** Delta Lake
- **Driver Class:** `org.apache.hive.jdbc.HiveDriver`
- **JDBC URL:** `jdbc:hive2://localhost:10000/userdata;auth=noSasl`
- **CLI Connection (beeline):**
  ```bash
  beeline -u "jdbc:hive2://localhost:10000/userdata;auth=noSasl"
  ```
- **Spark Web UI:**
  Open browser at `http://localhost:4040` to view Spark jobs, stages, SQL DAGs, and storage memory.
