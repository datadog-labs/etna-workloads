D=$PWD/rc_tmp_data
rm -rf "$D"
initdb -k -D "$D" >/dev/null 2>&1
echo junk > "$D/global/pg_internal.init.123"
pg_checksums --check -D "$D" 2>&1 | sed 's/^pg_checksums: //' | grep -v '^Bad\|^Data\|^Files\|^Blocks\|^Checksum' 
echo "exit=$?"
pg_checksums --check -D "$D" >/dev/null 2>&1; echo "status=$?"
rm -rf "$D"
