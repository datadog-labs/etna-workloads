echo '\set i hash()' > bad-hash.sql
pgbench -n -f bad-hash.sql -t 1 postgres 2>&1 | grep -o 'unexpected number of arguments (hash)'
rm -f bad-hash.sql
