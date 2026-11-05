psql -X -q -c "CREATE CAST (timestamptz AS interval) WITH FUNCTION age(timestamptz) AS ASSIGNMENT"
pg_dump -s 2>&1 | grep -i 'CREATE CAST'
