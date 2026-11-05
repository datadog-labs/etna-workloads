create table tab_part_create (a int) partition by list (a);
create function func_part_create() returns trigger
  language plpgsql as $$
  begin
    execute 'create table tab_part_create_1 partition of tab_part_create for values in (1)';
    return null;
  end $$;
create trigger trig_part_create before insert on tab_part_create
  for each statement execute procedure func_part_create();
insert into tab_part_create values (1);
