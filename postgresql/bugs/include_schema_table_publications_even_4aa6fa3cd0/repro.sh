psql -X -q -c "create schema s1; create table s1.t(a int); create table public.u(a int); create publication p1 for table s1.t, public.u; create publication p2 for tables in schema s1;"
echo "--- exclude-table"
pg_dump -s --exclude-table=s1.t | grep -E '^ALTER PUBLICATION'
echo "--- exclude-schema"
pg_dump -s --exclude-schema=s1 | grep -E '^ALTER PUBLICATION'
