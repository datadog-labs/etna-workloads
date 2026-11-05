BEGIN;
CREATE FUNCTION pg_temp.twophase_func() RETURNS void AS ' SELECT ''a''::text; ' LANGUAGE SQL;
PREPARE TRANSACTION 'twophase_func';
ROLLBACK;
