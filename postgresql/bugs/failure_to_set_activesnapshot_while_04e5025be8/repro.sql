begin;
create function nochange(int) returns int
  as 'select $1 limit 1' language sql stable;
declare c cursor for select * from generate_series(1,5) limit nochange(3);
fetch all from c;
move backward all in c;
fetch all from c;
rollback;
