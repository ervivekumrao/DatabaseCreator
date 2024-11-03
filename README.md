# Database Creator

## Features

- Create `docker` based Database images and containers.
- Oracle, SQL Server, PostgreSQL, IBM DB2, MySQL, MongoDB supported.

## How to build database containers
Go to this project root directory, run `CreateDB.sh` file 

    ./CreateDB.sh

Below parameters can be used with above command
- `-t` or `--database-type` defines the database vendor. Accepted values are below
  > `oracle` for ORACLE database, 
  <br> `mssql` or `sql server` for Microsoft SQL Server database 
  <br> `PostgreSQL` or `postgres` for PostgreSQL database
  <br> `db2` for IBM DB2 database
  <br> `mysql` for MySQL database
  <br> `mongodb` for MongoDB database
- `-v` or `--database-version` defines the database version. Accepted values are below
  > Oracle: `latest` and `latest-23ai` can be used. As per document `latest` is for `19c` and `latest-23ai` for `23ai`.
  <br> Please see for supported versions: https://github.com/oracle/adb-free

  > SQL Server: `2017-latest`, `2019-latest` and `2022-latest`
  <br> Please see for supported versions: https://hub.docker.com/r/microsoft/mssql-server/

  > PostgreSQL: `12` to `17` or `latest`
  <br> Please see for supported versions: https://hub.docker.com/_/postgres/

  > IBM DB2: `latest`
  <br> Please see for supported versions: https://hub.docker.com/r/ibmcom/db2

  > MySQL: `latest`
  <br> Please see for supported versions: https://hub.docker.com/_/mysql/

  > MongoDB: `latest`
  <br> Please see for supported versions: https://hub.docker.com/_/mongo/

- `-n` or `--database-name` Give your docker container database name. This is useful when you have more than one database container. 
- `-p` or `--docker-port` Database inside container will use its default database port. However, this port can be mapped to the machine port on which container is running. So you can have more than one database container of same database type running on different port. Useful when you have more than one database container of same database type.
- `-i` or `--image-name` Give your built image name from which container will be created. Usually give image name when you want to have different type of databases or for same type of database when you want to have different database versions.
- `-r` or `--image-repo` In case you want to define your local docker image repository name. 
- `-h` or `--help` Access help section.

Sample command
  > ./CreateDB.sh -t mongoDB -n mydb -i myimg -p 88888

## Prerequisite 
- Supported on Linux based OS and on Linux in WSL.
- Docker installation required.
  > sudo apt install -y docker docker-buildx

## Built DB with custom credentials 
- Database configuration can be changed via `Database.properties` file. 
- Host, port, JDBC URL, Driver class and driver jar are for reference only and change has no effect on build time. 
- However, container port can be changed via `-p` build argument in `CreateDB` command.

## Troubleshoot
- Docker build and docker run command can fail due to conflicting name. Double check while you pass database name and image name in createDB command with existing images and containers.
- Sometimes your container may not be up in time due to this reason you see container is in unhealthy state or database, schema, user may be missing. Restart container:
  > docker restart CONTAINER_ID
- In case you want to clean every docker image and container created or downloaded and start fresh then stop all running containers and use below command:
  > docker volume prune -f && docker volume prune -af && docker image prune -f && docker image prune -af && docker system prune -f && docker system prune -af && docker container prune -f


 


