psql -X -q -c 'DROP SCHEMA public' -c 'CREATE SCHEMA public'
pg_dump -s --clean postgres | grep -E '^(GRANT|REVOKE)'
pg_dump -s postgres | grep -E '^(GRANT|REVOKE)'
