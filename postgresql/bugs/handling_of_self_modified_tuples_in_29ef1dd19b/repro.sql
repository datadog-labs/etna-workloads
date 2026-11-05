create table t(id int primary key, v text);
create function trg() returns trigger language plpgsql as $$
begin
  if new.v = 'b' then
    update t set v = 'trig' where id = old.id;
  end if;
  return new;
end $$;
create trigger t_b before update on t for each row execute function trg();
insert into t values (1,'a');
merge into t using (values (1)) as s(id) on t.id = s.id
  when matched then update set v = 'b';
select * from t;
