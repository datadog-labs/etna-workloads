CREATE FUNCTION bt_in(cstring) RETURNS bt AS 'boolin' LANGUAGE internal IMMUTABLE STRICT;
CREATE FUNCTION bt_out(bt) RETURNS cstring AS 'boolout' LANGUAGE internal IMMUTABLE STRICT;
CREATE TYPE bt(INPUT = bt_in, OUTPUT = bt_out);
SELECT count(*) FROM pg_depend d WHERE d.refobjid = 'bt'::regtype AND d.classid = 'pg_proc'::regclass;
DROP FUNCTION bt_in(cstring);
DROP TYPE bt CASCADE;
