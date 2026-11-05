D=$PWD/rw_data
rm -rf $D
initdb -D $D >/dev/null 2>&1
pg_resetwal -n -m 0,10 $D 2>&1 | grep -E "NextMultiXactId|must"
pg_resetwal -n -O 4294967295 $D 2>&1 | grep -E "NextMultiOffset|must"
pg_resetwal -n -O -1 $D 2>&1 | grep -E "NextMultiOffset|must"
rm -rf $D
