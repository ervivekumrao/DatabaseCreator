#!/usr/bin/env bash

(if (ls /opt/mssql-tools/bin/sqlcmd >/dev/null 2>&1); then export SQLCMD_PATH=/opt/mssql-tools/bin/sqlcmd; else export SQLCMD_PATH=/opt/mssql-tools18/bin/sqlcmd; fi && sleep 60s && "${SQLCMD_PATH}" -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -C -i /var/custom/setupDB.sql) &
/opt/mssql/bin/sqlservr