psql -X -q -c "SELECT lo_create(424242)" >/dev/null
psql -X -q -c "COMMENT ON LARGE OBJECT 424242 IS 'lo comment'"
pg_dump --binary-upgrade --schema-only | grep -E "LARGE OBJECT|lo comment"
