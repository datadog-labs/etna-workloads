"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
CREATE TABLE t1(a, b);
INSERT INTO t1 VALUES(1, 2);
SQL
# downgrade the schema file format number (header offset 44) to 1
printf '\001' | dd of=test.db bs=1 seek=47 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db 'ALTER TABLE t1 ADD c; SELECT * FROM t1;'
od -An -tu1 -j47 -N1 test.db
