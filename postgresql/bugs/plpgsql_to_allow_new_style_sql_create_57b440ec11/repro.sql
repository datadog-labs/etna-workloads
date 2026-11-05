do
$$
begin
  create function test1() returns int
    begin atomic
      select 2 + 2;
    end;
end
$$;
\sf test1
