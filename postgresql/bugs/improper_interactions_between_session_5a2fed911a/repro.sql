CREATE ROLE ra SUPERUSER;
CREATE ROLE rb SUPERUSER;
SET SESSION AUTHORIZATION ra;
SET ROLE rb;
BEGIN;
SET SESSION AUTHORIZATION rb;
SELECT session_user, current_user, current_setting('role');
ROLLBACK;
SELECT session_user, current_user, current_setting('role');
