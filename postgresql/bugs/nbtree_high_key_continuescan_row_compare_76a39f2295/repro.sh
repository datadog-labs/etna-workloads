psql -X -q -c "CREATE TABLE tbl (c1 int, c2 int, c3 int, c4 box, UNIQUE(c1,c2) INCLUDE(c3,c4))" \
 -c "INSERT INTO tbl SELECT x, 2*x, NULL, NULL FROM generate_series(1,300) AS x" -c "ANALYZE tbl"
# the buggy build loops forever in _bt_check_rowcompare; bound it with a timeout
if timeout 20 psql -X -q -c "SET enable_seqscan = off" -c "select * from tbl where (c1,c2,c3) < (262,1,1) limit 1" >/dev/null; then
  echo finished
else
  echo hung
  psql -X -q -c "select pg_terminate_backend(pid) from pg_stat_activity where query like 'select * from tbl%'" >/dev/null
fi
