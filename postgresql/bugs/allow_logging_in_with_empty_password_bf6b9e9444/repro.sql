CREATE ROLE r1 PASSWORD '';
SELECT rolpassword IS NULL AS pw_null FROM pg_authid WHERE rolname='r1';
ALTER ROLE r1 PASSWORD '';
SELECT rolpassword IS NULL AS pw_null FROM pg_authid WHERE rolname='r1';
DROP ROLE r1;
