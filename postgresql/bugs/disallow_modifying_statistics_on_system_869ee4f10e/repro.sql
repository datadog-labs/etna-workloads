create table t(id int);
select pg_catalog.pg_restore_attribute_stats('schemaname','public','relname','t','attname','xmin','inherited',false::boolean,'null_frac',0.1::real);
select pg_catalog.pg_clear_attribute_stats('public','t','ctid',false);
select attname from pg_stats where tablename='t';
