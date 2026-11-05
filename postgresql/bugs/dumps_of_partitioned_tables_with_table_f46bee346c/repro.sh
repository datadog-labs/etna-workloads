psql -X -q -c "CREATE TABLE p (id int) PARTITION BY LIST (id)" -c "ALTER TABLE p SET ACCESS METHOD heap"
pg_dump -s -t p | grep -E 'ACCESS METHOD|CREATE TABLE'
