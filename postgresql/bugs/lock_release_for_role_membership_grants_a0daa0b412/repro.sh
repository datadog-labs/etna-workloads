psql -X -q <<'S'
CREATE ROLE r_role;
CREATE ROLE r_member;
CREATE ROLE r_grantor;
GRANT r_role TO r_grantor WITH ADMIN OPTION;
SET ROLE r_grantor;
GRANT r_role TO r_member;
RESET ROLE;
S
( psql -X -q 2>&1 <<'S'
BEGIN;
DROP OWNED BY r_grantor;
SELECT pg_sleep(2);
COMMIT;
S
) &
sleep 1
psql -X -q -c "DROP OWNED BY r_grantor" 2>&1
wait
psql -X -q -c "DROP ROLE r_member" -c "DROP ROLE r_grantor" -c "DROP ROLE r_role"
