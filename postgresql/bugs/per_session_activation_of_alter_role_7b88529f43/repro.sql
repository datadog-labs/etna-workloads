CREATE ROLE r_cur;
CREATE ROLE r_sr LOGIN SUPERUSER;
GRANT r_cur TO r_sr;
ALTER ROLE r_sr SET ROLE = r_cur;
\c - r_sr
SELECT current_user, session_user;
\c - postgres
ALTER ROLE r_sr RESET ROLE;
DROP ROLE r_sr;
DROP ROLE r_cur;
