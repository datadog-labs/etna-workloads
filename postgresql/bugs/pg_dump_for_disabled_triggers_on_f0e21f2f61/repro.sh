psql -X -q <<'SQL'
create table p (a int) partition by list (a);
create function f() returns trigger language plpgsql as 'begin return null; end';
create trigger t after insert on p for each row execute function f();
create table p1 partition of p for values in (1);
alter table p1 disable trigger t;
SQL
pg_dump -s --no-owner postgres | grep -E 'TRIGGER'
psql -X -q -c 'drop table p; drop function f'
