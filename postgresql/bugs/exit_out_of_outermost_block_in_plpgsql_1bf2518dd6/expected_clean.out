do $$
<<outerblock>>
begin
  <<innerblock>>
  begin
    exit outerblock;
    raise notice 'should not get here';
  end;
  raise notice 'should not get here, either';
end$$;
