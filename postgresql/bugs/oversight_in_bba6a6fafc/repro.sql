create table p (a int) partition by list (a);
create table c (a int);
create function f() returns trigger language plpgsql as $$ begin return null; end $$;
create trigger t after delete on c referencing old table as o for each statement execute function f();
alter table p attach partition c for values in (1);
select relispartition from pg_class where relname='c';
