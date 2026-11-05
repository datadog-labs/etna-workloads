psql -X -q -c "create table cp(a int)"
echo "COPY cp FROM stdin" > copy.sql
timeout 10 pgbench -n -t 1 -f copy.sql postgres 2>&1 | grep -o "COPY is not supported"
timeout 10 pgbench -n -t 1 -f copy.sql postgres >/dev/null 2>&1; r=$?
if [ $r = 124 ]; then echo hang; else echo "exit $r"; fi
