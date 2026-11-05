set check_function_bodies = off;
create function func_with_bad_set() returns int as $$ select 1 $$
language sql
set default_text_search_config = no_such_config;
select proname from pg_proc where proname='func_with_bad_set';
