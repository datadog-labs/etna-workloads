# The sqlite_master row is too big for page 1, so page 1 becomes an interior
# page with zero cells and one child (virtual root). Zero its right-child pointer.
rm -f test.db
ct="CREATE TABLE t1(c0"
i=0
while [ ${#ct} -lt 950 ]; do i=$((i+1)); ct="$ct, c$i"; done
"$SQLITE3" -batch -init /dev/null test.db "PRAGMA page_size=1024; $ct)" 2>&1
printf '\0\0\0\0' | dd of=test.db bs=1 seek=108 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db "SELECT * FROM sqlite_master;" 2>&1
echo "exit=$?"
