create function f() returns int language sql set search_path=pg_catalog set local_preload_libraries='Mixed/Case','', 'a"b' as 'select 1';
select pg_get_functiondef('f'::regproc);
