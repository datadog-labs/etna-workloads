CREATE DATABASE regress_db;
CREATE SUBSCRIPTION regress_sub1 CONNECTION 'dbname=regress_db' PUBLICATION regress_pub WITH (connect=false);
SET statement_timeout = '5s';
DROP SUBSCRIPTION regress_sub1;
RESET statement_timeout;
DROP SUBSCRIPTION IF EXISTS regress_sub1;
DROP DATABASE regress_db;
