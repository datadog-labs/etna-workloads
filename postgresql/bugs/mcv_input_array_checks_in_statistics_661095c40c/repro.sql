CREATE TABLE t(id int);
INSERT INTO t SELECT g FROM generate_series(1,5) g;
ANALYZE t;
SELECT pg_restore_attribute_stats('schemaname','public','relname','t','attname','id','inherited',false,'null_frac',0.24::real,'most_common_vals','{2,1,3}'::text,'most_common_freqs','{0.3,0.25}'::real[]);
SELECT pg_restore_attribute_stats('schemaname','public','relname','t','attname','id','inherited',false,'null_frac',0.25::real,'most_common_vals','{{2,1},{3,4}}'::text,'most_common_freqs','{0.3,0.25}'::real[]);
SELECT null_frac, most_common_vals IS NULL FROM pg_stats WHERE tablename='t';
