create function simplesql() returns int language sql as $$select 1 / 0$$;
create function simplecaller() returns int language plpgsql
as $$
declare x int;
begin
  select simplesql() into x;
  return x;
end$$;
select simplecaller();
create or replace function simplesql() returns int language sql as $$select 2 + 2$$;
select simplecaller();
