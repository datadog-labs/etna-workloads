create table parted_trig (a int) partition by list (a);
create table parted_trig1 partition of parted_trig for values in (1);
create table parted_trig2 partition of parted_trig for values in (2);
insert into parted_trig values (2);
create function trigger_notice() returns trigger as $$
  begin
    raise notice 'trigger % on % % % for %', TG_NAME, TG_TABLE_NAME, TG_WHEN, TG_OP, TG_LEVEL;
    if TG_OP = 'DELETE' then return OLD; else return NEW; end if;
  end; $$ language plpgsql;
create trigger t_after_row after insert or update or delete on parted_trig
  for each row execute procedure trigger_notice();
merge into parted_trig using (select 1) as ss on true
  when matched and a = 2 then update set a = 1;
select * from parted_trig;
