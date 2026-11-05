psql -X -q -c "create table t1(a int, b int); create table t2(a int, b int); create statistics s1 on a,b from t1; create statistics s2 on a,b from t2;"
pg_dump -s -T t1 postgres | grep -E 'CREATE (TABLE|STATISTICS)'
