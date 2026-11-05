for e in "9223372036854775807 + 1" "-9223372036854775807 - 2" "4611686018427387904 * 2"; do
  echo "\\set x $e" > s.pgb
  echo "\\set y :x + 0" >> s.pgb
  echo "SELECT :y;" >> s.pgb
  pgbench -n -t 1 -f s.pgb postgres 2>&1 | grep -E "out of range|processed"
done
rm -f s.pgb
