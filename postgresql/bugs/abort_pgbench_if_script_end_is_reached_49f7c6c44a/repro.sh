printf '\\startpipeline\n' > "$PWD/p.sql"
pgbench -t 2 -n -M extended -f "$PWD/p.sql" postgres 2>&1 | grep -c 'end of script reached with pipeline open'
echo "exit: ${PIPESTATUS:-x}" >/dev/null
pgbench -t 2 -n -M extended -f "$PWD/p.sql" postgres >/dev/null 2>&1; echo "status $?"
rm -f "$PWD/p.sql"
