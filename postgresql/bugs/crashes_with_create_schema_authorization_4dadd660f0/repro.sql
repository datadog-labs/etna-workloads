SELECT format('CREATE SCHEMA AUTHORIZATION %I CREATE TABLE %I.t1 (a int) CREATE VIEW %I.v1 AS SELECT a FROM %I.t1', current_user, current_user, current_user, current_user) \gexec
SELECT count(*) FROM pg_class WHERE relname IN ('t1','v1');
CREATE SCHEMA AUTHORIZATION CURRENT_ROLE CREATE TABLE t2 (a int);
SELECT 1;
