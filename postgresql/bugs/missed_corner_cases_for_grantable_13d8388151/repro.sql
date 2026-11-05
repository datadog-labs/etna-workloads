CREATE ROLE r_adm NOSUPERUSER;
GRANT SET ON PARAMETER work_mem TO r_adm;
GRANT SET ON PARAMETER log_min_messages TO r_adm;
ALTER ROLE r_adm SET work_mem = '8MB';
ALTER ROLE r_adm SET log_min_messages = 'error';
SET SESSION AUTHORIZATION r_adm;
ALTER ROLE r_adm RESET ALL;
RESET SESSION AUTHORIZATION;
SELECT setconfig FROM pg_db_role_setting WHERE setrole = 'r_adm'::regrole;
