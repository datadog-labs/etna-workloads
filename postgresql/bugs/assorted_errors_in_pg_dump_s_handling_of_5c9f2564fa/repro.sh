psql -X -q <<'SQL'
create role r_stat;
create schema s1;
create table t(a int, b int);
create statistics s1.st on a, b from t;
alter statistics s1.st owner to r_stat;
SQL
pg_dump -s postgres | grep -i -E 'STATISTICS'
