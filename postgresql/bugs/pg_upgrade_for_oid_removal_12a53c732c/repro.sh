psql -X -q -c "SELECT lo_create(424242)" >/dev/null
psql -X -q -c "GRANT SELECT ON LARGE OBJECT 424242 TO PUBLIC"
pg_dump --binary-upgrade -s | grep -i "LARGE OBJECT.*424242" | grep -i -E "GRANT|REVOKE"
