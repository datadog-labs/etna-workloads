create table bar1 (a integer, b integer not null default 1) partition by range (a);
create table bar2 (a integer);
insert into bar2 values (1);
alter table bar2 add column b integer not null default 1;
alter table bar1 attach partition bar2 default;
select * from bar1;
create function xtrig() returns trigger language plpgsql as $$
  declare r record;
  begin
    for r in select * from old loop
      raise info 'a=%, b=%', r.a, r.b;
    end loop;
    return NULL;
  end;
$$;
create trigger xtrig after update on bar1 referencing old table as old
  for each statement execute procedure xtrig();
update bar1 set a = a + 1;
