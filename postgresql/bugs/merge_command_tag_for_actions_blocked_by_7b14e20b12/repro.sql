create table t(id int, v int);
insert into t values (1,1),(2,2);
create function skip() returns trigger language plpgsql as $$ begin return null; end $$;
create trigger s before update or delete on t for each row execute function skip();
create table src(id int);
insert into src values (1),(2);
do $$
declare n int;
begin
merge into t using src on t.id=src.id when matched and src.id=1 then update set v=10 when matched then delete;
get diagnostics n := row_count;
raise notice 'row_count = %', n;
end $$;
