SET allow_in_place_tablespaces = true;
CREATE TABLESPACE regress_tblspace LOCATION '';
SELECT regexp_replace(pg_tablespace_location(oid), '(pg_tblspc)/(\d+)', '\1/NNN')
  FROM pg_tablespace WHERE spcname = 'regress_tblspace';
DROP TABLESPACE regress_tblspace;
