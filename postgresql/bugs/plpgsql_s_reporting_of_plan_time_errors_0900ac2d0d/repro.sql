\set VERBOSITY default
create function fail() returns int language plpgsql as $$
begin
  return 1/0;
end $$;
select fail();
select fail();
