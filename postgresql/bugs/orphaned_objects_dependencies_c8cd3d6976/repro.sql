create schema testschema;
begin;
create function testschema.foo() returns int as 'select 1' language sql;
select count(*) from pg_locks l where locktype='object' and classid='pg_namespace'::regclass
  and objid='testschema'::regnamespace and mode='AccessShareLock';
commit;
