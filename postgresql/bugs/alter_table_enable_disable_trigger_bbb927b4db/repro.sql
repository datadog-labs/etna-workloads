create table parent (a int) partition by list (a);
create table child1 partition of parent for values in (1);
create function trig_nothing() returns trigger language plpgsql as $$ begin return null; end $$;
create trigger tg after insert on parent for each row execute procedure trig_nothing();
alter table only parent enable always trigger tg;
select tgrelid::regclass, tgname, tgenabled from pg_trigger
  where tgrelid in ('parent'::regclass, 'child1'::regclass) order by tgrelid::regclass::text;
alter table parent enable always trigger tg;
select tgrelid::regclass, tgname, tgenabled from pg_trigger
  where tgrelid in ('parent'::regclass, 'child1'::regclass) order by tgrelid::regclass::text;
