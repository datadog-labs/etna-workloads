# Rationale

Changed hunk: `src/include/catalog/pg_proc.dat`, entry for `pg_mcv_list_items` (oid 3427).
Traces to the fix.patch hunk that changed `proallargtypes` from `{pg_mcv_list,int4,text,_bool,float8,float8}` to `{pg_mcv_list,int4,_text,_bool,float8,float8}`.
Reverted: the `values` output column is declared `text` again instead of `text[]`. The C function in mcv.c (pg_stats_ext_mcvlist_items) still builds a text[] array datum, so the declared column type no longer matches the data it returns. The result is wrong or garbled output for the `values` column.

Failing oracle case: src/test/regress||stats_ext
