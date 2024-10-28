CREATE TABLE userdata.test (source int, cost int, part_number int);
GRANT ALL PRIVILEGES ON *.* TO 'userid'@'%';
FLUSH PRIVILEGES;
CREATE USER 'userid'@'localhost' IDENTIFIED BY 'userPassword';
GRANT ALL PRIVILEGES ON *.* TO 'userid'@'localhost';
FLUSH PRIVILEGES;