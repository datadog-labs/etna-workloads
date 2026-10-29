{
echo "CREATE VIRTUAL TABLE t1 USING fts5(x);"
echo "INSERT INTO t1(t1, rank) VALUES('pgsz', 32);"
for ((i=0;i<1100;i++)); do
echo "INSERT INTO t1 VALUES('abc def ghi');INSERT INTO t1 VALUES('jkl mno pqr');INSERT INTO t1(t1) VALUES('optimize');"
done
echo "SELECT count(*) FROM t1('mno');"
} | "$SQLITE3" -batch -init /dev/null :memory: 2>&1 | head -n 3

