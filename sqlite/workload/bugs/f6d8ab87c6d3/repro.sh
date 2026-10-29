"$SQLITE3" -batch -init /dev/null t.db "create table t3(a,b); insert into t3 values(1,2);"
{
  echo ".timeout 10000"
  echo "select count(*) from sqlite_master;"
  sleep 2
  echo "select * from t3;"
  echo "select name from sqlite_master;"
} | "$SQLITE3" -batch -init /dev/null t.db 2>&1 &
sleep 1
{
  echo "begin exclusive;"
  echo "create table t4(x);"
  sleep 2
  echo "commit;"
} | "$SQLITE3" -batch -init /dev/null t.db 2>&1
wait
