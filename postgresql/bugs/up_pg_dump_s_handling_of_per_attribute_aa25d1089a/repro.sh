psql -X -q -c "CREATE TABLE tc (a text COMPRESSION pglz, b text)"
pg_dump -s -t tc postgres | grep -i -E "compression|^CREATE TABLE|^    [ab] "
