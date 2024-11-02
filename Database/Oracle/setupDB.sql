CREATE USER userid IDENTIFIED BY "0raclePa55w0rd" QUOTA UNLIMITED ON DATA;
CREATE TABLE userid.test (source int, cost int, part_number int);
GRANT INSERT, SELECT, UPDATE, DELETE ON userid.test TO userid;
GRANT CREATE SESSION TO userid;
GRANT CREATE JOB TO userid;
GRANT CREATE MATERIALIZED VIEW TO userid;
GRANT CREATE PROCEDURE TO userid;
GRANT CREATE SEQUENCE TO userid;
GRANT CREATE SESSION TO userid;
GRANT CREATE SYNONYM TO userid;
GRANT CREATE TABLE TO userid;
GRANT CREATE TRIGGER TO userid;
GRANT CREATE TYPE TO userid;
GRANT CREATE VIEW TO userid;
GRANT CONNECT TO userid;
GRANT CONSOLE_DEVELOPER TO userid;
GRANT DWROLE TO userid;
GRANT RESOURCE TO userid;

BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled => TRUE,
        p_schema => 'userid',
        p_url_mapping_type => 'BASE_PATH',
        p_url_mapping_pattern => 'userid',
        p_auto_rest_auth=> TRUE
    );
    commit;
END;

ALTER USER userid QUOTA UNLIMITED ON DATA;
