psql -X -q -c 'create role "ru
xINJECT"' -c 'alter role "ru
xINJECT" set work_mem = 1234'
pg_dumpall -g | grep -c '^xINJECT"$'
