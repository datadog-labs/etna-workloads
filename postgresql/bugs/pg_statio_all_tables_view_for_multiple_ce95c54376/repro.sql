select position('LATERAL' in pg_get_viewdef('pg_statio_all_tables'::regclass)) > 0 as uses_lateral;
