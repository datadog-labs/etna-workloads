printf '\\startpipeline\n\\endpipeline\n\\startpipeline\nselect 1;\nselect 1;\n\\endpipeline\n' > "$PWD/pp.sql"
pgbench -n -M prepared -t 1 -f "$PWD/pp.sql" postgres >/dev/null 2>&1
echo "exit: $?"
rm -f "$PWD/pp.sql"
