select ts_rewrite('!!a'::tsquery, 'zzz'::tsquery, 'zzz'::tsquery);
select ts_rewrite('!!a & b'::tsquery, 'zzz'::tsquery, 'y'::tsquery);
