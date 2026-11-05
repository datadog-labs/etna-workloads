D=$PWD/sudata
rm -rf $D
initdb -D $D -A trust >/dev/null 2>&1
echo "SELECT pg_create_physical_replication_slot('s1', true);" | postgres --single -F -D $D postgres >/dev/null 2>&1
echo "create exit: $?"
echo "SELECT pg_replication_slot_advance('s1', pg_current_wal_lsn());" | postgres --single -F -D $D postgres >/dev/null 2>&1
echo "advance exit: $?"
rm -rf $D
