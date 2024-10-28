ALTER USER userid SET SEARCH_PATH TO public;
CREATE SCHEMA IF NOT EXISTS userdata AUTHORIZATION userid;
CREATE TABLE userdata.test (source int, cost int, part_number int);
GRANT USAGE ON SCHEMA userdata TO userid;
ALTER USER userid SET search_path = userdata;
ALTER DEFAULT PRIVILEGES FOR USER userid IN SCHEMA userdata GRANT ALL ON TABLES TO userid;
ALTER DEFAULT PRIVILEGES IN SCHEMA userdata GRANT EXECUTE ON FUNCTIONS TO userid;