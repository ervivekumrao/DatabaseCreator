#!/usr/bin/env bash

CONTAINER_DB_TYPE=mysql
CONTAINER_DB_VERSION=latest
CONTAINER_DB_NAME=localdb
CONTAINER_DB_PORT=55555
CONTAINER_IMAGE_NAME=img
CONTAINER_REPO_NAME=local.image

function show_usage() {
   printf "\n"
   printf "Usage: [options [values]]\n"
   printf "\n"
   printf "Options:\n"
   printf " -t|--database-type [database vendor you want to build. db2, mysql, postgres, mssql are accepted values.][Required] \n"
   printf " -v|--database-version [database vendor version. For SqlServer 2017-latest to 2022-latest are accepted but for all other latest or specific version can be used as value.][Optional] \n"
   printf " -n|--database-name [database name that you want to assign to your container in case you want to have more container.][Optional] \n"
   printf " -p|--docker-port [container port on which you want to access your db.][Optional] \n"
   printf " -i|--image-name [docker image name that you want to give in case you want to have more than one images.][Optional] \n"
   printf " -r|--image-repo [In case you want to assign your own repo name.][Optional] \n"
   printf " -h|--help, Print help\n"
   printf " For more info see: https://github.com/ervivekumrao/DatabaseCreator \n"
}

args=("$@")
for (( index=0; index<${#args[@]}; index+=2 )); do

  case ${args[$index],,} in
      -t | --database-type)
        j=$((index + 1))
        TYPE="${args[$j]}"
        if [ -n "${TYPE}" ] ; then
          CONTAINER_DB_TYPE=${TYPE}
        fi
        ;;

      -v | --database-version)
        j=$((index + 1))
        VERSION="${args[$j]}"
        if [ -n "${TYPE}" ] ; then
          CONTAINER_DB_VERSION=${VERSION}
        fi
        ;;

      -n | --database-name)
        j=$((index + 1))
        NAME="${args[$j]}"
        if [ -n "${TYPE}" ] ; then
          CONTAINER_DB_NAME=${NAME}
        fi
        ;;

      -p | --docker-port)
        j=$((index + 1))
        PORT="${args[$j]}"
        if [ -n "${TYPE}" ] ; then
          CONTAINER_DB_PORT=${PORT}
        fi
        ;;

      -i | --image-name)
        j=$((index + 1))
        NAME="${args[$j]}"
        if [ -n "${TYPE}" ] ; then
          CONTAINER_IMAGE_NAME=${NAME}
        fi
        ;;

      -r | --image-repo)
        j=$((index + 1))
             REPO="${args[$j]}"
             if [ -n "${TYPE}" ] ; then
               CONTAINER_REPO_NAME=${REPO}
             fi
        ;;

      *)
        show_usage
        exit
        ;;
    esac
done

function getProperty {
    < "$(pwd)/Database.properties" grep "$1" | cut -d'=' -f2 | tr -d '"'
}

rm -rf "$(pwd)/build"
mkdir "$(pwd)/build" || exit

case ${CONTAINER_DB_TYPE,,} in

  mysql)
    #MYSQL DB Build section
    printf "\n Building MYSQL"
    cp -rf "$(pwd)/Database/MYSQL/." "$(pwd)/build"

    dockerfile="$(pwd)/build/Dockerfile"
    sed -i "s/MYSQL_DATABASE_VALUE/$(getProperty 'MYSQL_DBNAME')/g" "${dockerfile}"
    sed -i "s/MYSQL_USER_VALUE/$(getProperty 'MYSQL_USER_ID')/g" "${dockerfile}"
    sed -i "s/MYSQL_PASSWORD_VALUE/$(getProperty 'MYSQL_USER_PASSWORD')/g" "${dockerfile}"
    sed -i "s/MYSQL_ROOT_PASSWORD_VALUE/$(getProperty 'MYSQL_ROOT_PASSWORD')/g" "${dockerfile}"

    cd "$(pwd)/build" || exit
    if [ -z "$(docker image inspect "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" &> /dev/null)" ]; then
      docker buildx build . --tag "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" --build-arg DB_VERSION="${CONTAINER_DB_VERSION}"
    fi
    docker run --privileged=true -d --name "${CONTAINER_DB_NAME}" -p "${CONTAINER_DB_PORT}":3306 "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}"
    ;;

  db2)
    #IBM DB2 Build section
    printf "\n Building IBM DB2"
    cp -rf "$(pwd)/Database/IBMDB2/." "$(pwd)/build"

    dockerfile="$(pwd)/build/Dockerfile"
    sed -i "s/DB2_DB2INSTANCE_VALUE/$(getProperty 'DB2_DB2INSTANCE')/g" "${dockerfile}"
    sed -i "s/DB2_DB2INST1_PASSWORD_VALUE/$(getProperty 'DB2_DB2INST1_PASSWORD')/g" "${dockerfile}"
    sed -i "s/DB2_DBNAME_VALUE/$(getProperty 'DB2_DBNAME')/g" "${dockerfile}"
    sed -i "s/DB2_USERID_VALUE/$(getProperty 'DB2_USER_ID')/g" "${dockerfile}"
    sed -i "s/DB2_USERPASS_VALUE/$(getProperty 'DB2_USER_PASS')/g" "${dockerfile}"
    sed -i "s/DB2_USERSCHEMA_VALUE/$(getProperty 'DB2_USER_SCHEMA')/g" "${dockerfile}"

    cd "$(pwd)/build" || exit
    if [ -z "$(docker image inspect "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" &> /dev/null)" ]; then
      docker buildx build . --tag "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" --build-arg DB_VERSION="${CONTAINER_DB_VERSION}"
    fi
    docker run --privileged=true -d --name "${CONTAINER_DB_NAME}" -p "${CONTAINER_DB_PORT}":50000 "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}"
    ;;

  postgres | postgresql)
    #SQL Server Build section
    printf "\n Building PostgreSQL"
    cp -rf "$(pwd)/Database/PostgreSQL/." "$(pwd)/build"

    dockerfile="$(pwd)/build/Dockerfile"
    sed -i "s/POSTGRES_DB_VALUE/$(getProperty 'POSTGRES_DBNAME')/g" "${dockerfile}"
    sed -i "s/POSTGRES_USER_VALUE/$(getProperty 'POSTGRES_USER_ID')/g" "${dockerfile}"
    sed -i "s/POSTGRES_PASSWORD_VALUE/$(getProperty 'POSTGRES_USER_PASSWORD')/g" "${dockerfile}"
    sed -i "s/POSTGRES_SCHEMA_VALUE/$(getProperty 'POSTGRES_USER_SCHEMA')/g" "${dockerfile}"

    cd "$(pwd)/build" || exit
    if [ -z "$(docker image inspect "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" &> /dev/null)" ]; then
      docker buildx build . --tag "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" --build-arg DB_VERSION="${CONTAINER_DB_VERSION}"
    fi
    docker run --privileged=true -d --name "${CONTAINER_DB_NAME}" -p "${CONTAINER_DB_PORT}":5432 "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}"
    ;;

  oracle)
    #Oracle Build section
    printf "\n Building Oracle DB"
    cp -rf "$(pwd)/Database/Oracle/." "$(pwd)/build"

    dockerfile="$(pwd)/build/Dockerfile"
    sed -i "s/WALLET_PASSWORD_VALUE/$(getProperty 'ORACLE_WALLET_PASSWORD')/g" "${dockerfile}"
    sed -i "s/ADMIN_PASSWORD_VALUE/$(getProperty 'ORACLE_ADMIN_PASSWORD')/g" "${dockerfile}"
    sed -i "s/DATABASE_NAME_VALUE/$(getProperty 'ORACLE_DBNAME')/g" "${dockerfile}"
    sed -i "s/USER_NAME_VALUE/$(getProperty 'ORACLE_USER_ID')/g" "${dockerfile}"
    sed -i "s/USER_PASSWORD_VALUE/$(getProperty 'ORACLE_USER_PASSWORD')/g" "${dockerfile}"

    cd "$(pwd)/build" || exit
    if [ -z "$(docker image inspect "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" &> /dev/null)" ]; then
      docker buildx build . --tag "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" --build-arg DB_VERSION="${CONTAINER_DB_VERSION}"
    fi
    docker run --privileged=true -d --name "${CONTAINER_DB_NAME}" -p "${CONTAINER_DB_PORT}":1521 --cap-add SYS_ADMIN --device /dev/fuse "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}"
    ;;

  mssql |"sql server")
    #SQL Server Build section
    printf "\n Building SQL Server"
    cp -rf "$(pwd)/Database/SqlServer/." "$(pwd)/build"

    dockerfile="$(pwd)/build/Dockerfile"
    sed -i "s/MSSQL_SA_PASSWORD_VALUE/$(getProperty 'MSSQL_SA_PASSWORD')/g" "${dockerfile}"
    sed -i "s/MSSQL_DB_VALUE/$(getProperty 'MSSQL_DBNAME')/g" "${dockerfile}"
    sed -i "s/MSSQL_USER_VALUE/$(getProperty 'MSSQL_USER_ID')/g" "${dockerfile}"
    sed -i "s/MSSQL_PASSWORD_VALUE/$(getProperty 'MSSQL_USER_PASSWORD')/g" "${dockerfile}"
    sed -i "s/MSSQL_SCHEMA_VALUE/$(getProperty 'MSSQL_USER_SCHEMA')/g" "${dockerfile}"

    if [ "${CONTAINER_DB_VERSION}" = latest ]; then
      CONTAINER_DB_VERSION=2022-latest
    fi
    cd "$(pwd)/build" || exit
    if [ -z "$(docker image inspect "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" &> /dev/null)" ]; then
      docker buildx build . --tag "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" --build-arg DB_VERSION="${CONTAINER_DB_VERSION}"
    fi
    docker run --privileged=true -d --name "${CONTAINER_DB_NAME}" -p "${CONTAINER_DB_PORT}":1433 "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}"
    ;;

  mongodb)
    #MongoDB Build section
    printf "\n Building MongoDB"
    cp -rf "$(pwd)/Database/MongoDB/." "$(pwd)/build"

    dockerfile="$(pwd)/build/Dockerfile"
    sed -i "s/MONGO_INITDB_DATABASE_VALUE/$(getProperty 'MONGODB_DBNAME')/g" "${dockerfile}"
    sed -i "s/MONGO_INITDB_ROOT_USERNAME_VALUE/$(getProperty 'MONGODB_USER_ID')/g" "${dockerfile}"
    sed -i "s/MONGO_INITDB_ROOT_PASSWORD_VALUE/$(getProperty 'MONGODB_USER_PASSWORD')/g" "${dockerfile}"
    sed -i "s/MONGO_INITDB_SCHEMA_VALUE/$(getProperty 'MONGODB_USER_SCHEMA')/g" "${dockerfile}"

    cd "$(pwd)/build" || exit
    if [ -z "$(docker image inspect "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" &> /dev/null)" ]; then
      docker buildx build . --tag "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}" --build-arg DB_VERSION="${CONTAINER_DB_VERSION}"
    fi
    docker run --privileged=true -d --name "${CONTAINER_DB_NAME}" -p "${CONTAINER_DB_PORT}":27017 "${CONTAINER_REPO_NAME}":"${CONTAINER_IMAGE_NAME}"
    ;;

  *)
    printf "\n unknown DB type."
    ;;
esac

#Check if container created
if [ "$(docker inspect -f "{{.State.Running}}" "${CONTAINER_DB_NAME}")" = true ];
then
     printf "\n Container %s exists." "${CONTAINER_DB_NAME}"
else
     printf "\n Container %s missing, error messages." "${CONTAINER_DB_NAME}"
     exit
fi

#DB Container health check
printf "\n Container have started; now waiting for container to be in healthy state..."
i=0
while [ "$( docker container inspect -f '{{.State.Health.Status}}' "${CONTAINER_DB_NAME}" )" != "healthy" ] && [ $i != 60 ]; do
sleep 10s
if [ $i = 30  ]; then
  printf "\n DB container is not healthy in %s minute now attempting restart on " "$(( i * 10 ))"
  docker restart "${CONTAINER_DB_NAME}"
  printf "\n checking health status again"
fi
((i++))
done

if [ "$( docker container inspect -f '{{.State.Health.Status}}' "${CONTAINER_DB_NAME}" )" = "healthy"  ]; then
  printf "\n DB container is healthy now.\n"
else
  printf "\n DB container is health check fail. Check manually if not working try building it again.\n"
fi

rm -rf ../build