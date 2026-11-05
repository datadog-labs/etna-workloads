select pg_typeof(array['11 22 33'::int2vector]);
select array['11 22 33'::oidvector];
select pg_typeof(array(select '11 22 33'::oidvector from generate_series(1,2)));
select array(select '11 22 33'::oidvector from generate_series(1,2));
