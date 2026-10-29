"$SQLITE3" -batch -init /dev/null :memory: "PRAGMA ignore_check_constraints=1; CREATE TABLE t(x CHECK(abs(x)>=0)); INSERT INTO t VALUES(-9223372036854775808);" ".clone new.db"
echo "exit $?"
