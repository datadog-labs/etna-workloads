CREATE ROLE r1;
DROP ROLE r1, r1;
SELECT count(*) FROM pg_roles WHERE rolname='r1';
