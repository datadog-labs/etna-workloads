psql -X -q -c "create database nopub" 
psql -X -q -d nopub -c "drop schema public"
pg_dump --no-sync -c nopub >/dev/null 2>$PWD/err.txt
echo "pg_dump exit: $?"
rm -f $PWD/err.txt
