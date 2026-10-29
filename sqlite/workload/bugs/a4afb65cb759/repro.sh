# One busy-handler budget: with .timeout 500 a blocked BEGIN IMMEDIATE should
# give up after ~0.5s; the bug makes the btree layer restart the counter so it
# waits about twice as long.
"$SQLITE3" t.db "create table t1(x);"
( echo "begin exclusive;"; sleep 4 ) | "$SQLITE3" t.db >/dev/null 2>&1 &
sleep 0.5
s=$(date +%s%N)
"$SQLITE3" t.db ".timeout 500" "begin immediate;" 2>&1
e=$(( ($(date +%s%N) - s) / 1000000 ))
if [ $e -lt 800 ]; then echo "waited short (single budget)"; else echo "waited long (budget doubled)"; fi
wait
