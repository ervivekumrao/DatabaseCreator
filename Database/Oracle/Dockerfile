ARG DB_VERSION
#FROM ghcr.io/oracle/adb-free:$DB_VERSION
FROM ghcr.io/oracle/adb-free:latest
#FROM ghcr.io/oracle/adb-free:latest-23ai

EXPOSE 1521

#ENV WORKLOAD_TYPE ADW
ENV WORKLOAD_TYPE ATP
ENV WALLET_PASSWORD 0raclePa55w0rd
ENV ADMIN_PASSWORD 0raclePa55w0rd
ENV DATABASE_NAME oradb

COPY --chmod=0777 setupDB.sql /u01/scripts/setupDB.sql

# Add setupDB.sql run command to default /u01/scripts/entrypoint.sh file
RUN sed -i -e 's/# Tail on alert log and wait (otherwise container will exit)/#Execute setupDB.sql file \necho \"@\/u01\/scripts\/setupDB.sql\" | sqlplus admin\/\"${ADMIN_PASSWORD}\"@localhost:1521\/\"${DATABASE_NAME}\" \n\n# Tail on alert log and wait (otherwise container will exit)/g' /u01/scripts/entrypoint.sh