D=$PWD/rr_data
rm -rf "$D"
initdb -D "$D" >/dev/null 2>&1
f=$D/global/pg_control
size=$(wc -c < "$f")
head -c 16 "$f" > "$D/hdr"
cat "$D/hdr" > "$f"
tail=$((size-16))
head -c $tail /dev/zero >> "$f"
pg_resetwal -n "$D" 2>&1 | head -3
echo "exit: $?"
pg_resetwal -n "$D" >/dev/null 2>&1; echo "status: $?"
rm -rf "$D"
