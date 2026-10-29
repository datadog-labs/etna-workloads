"$SQLITE3" -batch -init /dev/null t.db "create table t1(a); insert into t1 values(1);"
printf '\003' | dd of=t.db bs=1 seek=18 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null t.db "select * from t1;" ".databases" | sed "s|: .* r|: r|"
