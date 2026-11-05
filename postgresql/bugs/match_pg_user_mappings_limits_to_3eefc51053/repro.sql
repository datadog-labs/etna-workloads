CREATE FOREIGN DATA WRAPPER w;
CREATE SERVER s FOREIGN DATA WRAPPER w;
CREATE ROLE r_unpriv;
CREATE USER MAPPING FOR r_unpriv SERVER s OPTIONS (password 'secret');
SET ROLE r_unpriv;
SELECT srvname, usename, umoptions FROM pg_user_mappings;
RESET ROLE;
