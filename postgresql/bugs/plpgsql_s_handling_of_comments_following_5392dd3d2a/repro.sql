create or replace function case_comment(int) returns text as $$
begin
  case $1
    when 1 -- comment before THEN
      then return 'one';
    else
      return 'other';
  end case;
end;
$$ language plpgsql immutable;
select case_comment(1);
