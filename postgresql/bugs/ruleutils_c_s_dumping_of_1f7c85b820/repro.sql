create view tt19v as
select 'foo'::text = any((select array['abc','def','foo']::text[])::text[]) c2;
select pg_get_viewdef('tt19v', true);
