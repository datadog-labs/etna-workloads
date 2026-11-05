select 'xxx' ~ '(.){0}(\1)' as f;
select 'xxx' ~ '((.)){0}(\2)' as f;
select 'xyz' ~ '((.)){0}(\2){0}' as t;
