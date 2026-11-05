select 1 as x \gset
select a from generate_series(1, 10) as a where a = 11 \gset
\echo :ROW_COUNT :ERROR
