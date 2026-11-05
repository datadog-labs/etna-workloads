D=$(mktemp -d -p "$PWD")
for s in 1 2 3; do
  mkfifo $D/f$s
  psql -X -q -At -f $D/f$s >$D/o$s 2>&1 &
done
exec 3>$D/f1 4>$D/f2 5>$D/f3
psql -X -q -c "CREATE TABLE tab_freeze (id int PRIMARY KEY, name char(3), x int); INSERT INTO tab_freeze VALUES (1,'111',0),(3,'333',0);"
w() { eval "echo \"\$2\" >&$1"; sleep 1; }
w 3 "BEGIN;"; w 4 "BEGIN;"; w 5 "BEGIN;"
w 3 "UPDATE tab_freeze SET x = x + 1 WHERE id = 3;"
w 4 "SELECT id FROM tab_freeze WHERE id = 3 FOR KEY SHARE;"
w 5 "SELECT id FROM tab_freeze WHERE id = 3 FOR KEY SHARE;"
w 3 "UPDATE tab_freeze SET x = x + 1 WHERE id = 3;"
w 3 "COMMIT;"; w 4 "COMMIT;"
psql -X -q -c "VACUUM FREEZE tab_freeze" >/dev/null 2>&1
psql -X -q -c "SET enable_seqscan=false; SET enable_bitmapscan=false; SELECT * FROM tab_freeze WHERE id = 3" 2>&1 | head -5
w 5 "COMMIT;"
psql -X -q -c "VACUUM FREEZE tab_freeze" >/dev/null 2>&1
sleep 2
psql -X -q -c "SELECT * FROM tab_freeze ORDER BY name, id" 2>&1 | head -8
exec 3>&- 4>&- 5>&-
wait
rm -rf $D
