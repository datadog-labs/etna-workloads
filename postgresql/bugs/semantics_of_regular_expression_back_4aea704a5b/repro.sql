select 'xx' ~ '(^.)\1' as a;
select regexp_match('abc abc abc', '(^\w+).*\1');
select regexp_match('abc abc abc', '(\w+(?= )).*\1');
