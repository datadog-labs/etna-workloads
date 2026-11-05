create table t (a int) partition by range (a);
create table t1 partition of t for values from (1) to (2);
create function tn() returns trigger language plpgsql as $$ begin return null; end $$;
create trigger trig after insert on t for each row execute procedure tn();
alter table t detach partition t1;
drop trigger trig on t1;
alter table t attach partition t1 for values from (1) to (2);
select tgrelid::regclass, tgname from pg_trigger where not tgisinternal order by 1;
