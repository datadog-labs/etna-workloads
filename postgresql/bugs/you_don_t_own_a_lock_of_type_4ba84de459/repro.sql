SET allow_in_place_tablespaces = true;
CREATE TABLESPACE regress_repro_ts LOCATION '';
\c -
BEGIN;
GRANT ALL ON TABLESPACE regress_repro_ts TO PUBLIC;
ROLLBACK;
\c -
DROP TABLESPACE regress_repro_ts;
