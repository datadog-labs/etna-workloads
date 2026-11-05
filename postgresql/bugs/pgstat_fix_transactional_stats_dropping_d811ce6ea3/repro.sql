CREATE table t1 as select generate_series(1,10) a;
SELECT oid AS dboid from pg_database where datname = current_database() \gset
SET enable_seqscan TO off;
CREATE index i1 on t1(a);
SELECT 'i1'::regclass::oid AS i1_oid \gset
select a from t1 where a = 3;
SELECT pg_stat_force_next_flush();
SELECT pg_stat_have_stats('relation', :dboid, :i1_oid);
DROP index i1;
SELECT pg_stat_have_stats('relation', :dboid, :i1_oid);
BEGIN;
CREATE index i1 on t1(a);
SELECT 'i1'::regclass::oid AS i1_oid \gset
select a from t1 where a = 3;
ROLLBACK;
SELECT pg_stat_have_stats('relation', :dboid, :i1_oid);
