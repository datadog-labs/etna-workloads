psql -X -q -c "CREATE PUBLICATION pub1" -c "COMMENT ON PUBLICATION pub1 IS 'c'"
pg_dump -Fc -f $PWD/r.dump postgres
pg_restore --no-publications -f - $PWD/r.dump | grep -c 'COMMENT ON PUBLICATION'
rm -f $PWD/r.dump
