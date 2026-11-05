CREATE SCHEMA testns;
ALTER DEFAULT PRIVILEGES IN SCHEMA testns,testns GRANT SELECT ON TABLES TO public,public;
SELECT count(*) FROM pg_default_acl;
