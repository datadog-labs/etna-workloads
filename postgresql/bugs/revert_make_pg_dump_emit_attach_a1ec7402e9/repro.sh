psql -X -q -c "create table p (a int) partition by range (a); create table p1 partition of p for values from (1) to (10);"
pg_dump -s -t 'p*' | grep -E 'PARTITION'
