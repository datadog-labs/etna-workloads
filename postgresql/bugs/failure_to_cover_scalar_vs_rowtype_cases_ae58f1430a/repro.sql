create type compostype as (x int, y varchar);
create function compos() returns compostype as $$
declare x int := 42;
begin
  return x;
end;
$$ language plpgsql;
select * from compos();
create function compos2() returns int as $$
declare v compostype;
begin
  v := (1, 'hello');
  return v;
end;
$$ language plpgsql;
select compos2();
