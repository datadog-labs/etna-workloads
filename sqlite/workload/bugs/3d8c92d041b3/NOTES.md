Tries RENAME TABLE, RENAME COLUMN and DROP COLUMN on eponymous virtual tables (generate_series, pragma_compile_options).
Clean shell: "table X may not be altered" for each. Buggy shell: the TF_Eponymous check is missing, so the errors differ (or the statements proceed differently).
