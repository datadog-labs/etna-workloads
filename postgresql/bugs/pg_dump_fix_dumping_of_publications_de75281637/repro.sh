psql -X -q -c "create table t1(a int); create table t2(a int); create publication p for table t1, t2;"
pg_dump --binary-upgrade -s postgres 2>&1 | grep -i 'PUBLICATION'
echo "exit: $?"
