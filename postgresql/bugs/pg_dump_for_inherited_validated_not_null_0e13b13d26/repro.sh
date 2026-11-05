psql -X -q <<'SQL'
create table rp (a int);
create table rc () inherits (rp);
alter table rp add not null a not valid;
alter table rc validate constraint rp_a_not_null;
SQL
pg_dump -s -t rp -t rc postgres | grep -i 'not null'
