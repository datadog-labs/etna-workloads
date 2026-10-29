printf "CREATE TABLE t2(x TEXT PRIMARY KEY);\nINSERT INTO t2 VALUES(CAST(x'ff' || 'hello' AS TEXT));\nEXPLAIN QUERY PLAN SELECT x FROM t2 WHERE x LIKE '\xff%%';\nSELECT length(x) FROM t2 WHERE x LIKE '\xff%%';\n" | "$SQLITE3" -batch -init /dev/null :memory: 2>&1
echo "exit $?"
