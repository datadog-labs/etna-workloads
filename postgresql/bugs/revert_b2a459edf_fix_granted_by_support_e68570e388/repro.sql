CREATE ROLE r1; CREATE ROLE r2; CREATE ROLE r3;
GRANT r1 TO r2;
REVOKE r1 FROM r2 GRANTED BY nonexistent_role;
REVOKE r1 FROM r2 GRANTED BY r3;
SELECT count(*) FROM pg_auth_members m JOIN pg_roles r ON r.oid=m.roleid WHERE r.rolname='r1';
