pg_dump --format=plain postgres | grep -c '^\\restrict '
pg_dump --format=plain postgres | grep -c '^\\unrestrict '
