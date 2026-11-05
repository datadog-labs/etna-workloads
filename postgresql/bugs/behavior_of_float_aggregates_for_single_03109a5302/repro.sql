SELECT var_pop('inf'::float8), stddev_pop('nan'::float8);
SELECT var_pop('inf'::float4), stddev_pop('inf'::float4);
SELECT covar_pop('inf'::float8, 1), regr_sxx('inf'::float8, 'inf'::float8);
