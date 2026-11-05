psql -X -q <<SQL
SET allow_in_place_tablespaces = on;
CREATE TABLESPACE inplace LOCATION '';
SQL
rm -rf bkp_t
pg_basebackup --no-sync -cfast -D bkp_t -Ft -X none 2>/dev/null
ls bkp_t | sed 's/^[0-9][0-9]*\.tar$/TBLSPC.tar/'
rm -rf bkp_t
