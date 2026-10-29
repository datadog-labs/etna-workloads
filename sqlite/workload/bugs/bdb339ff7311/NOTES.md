Reproducer: CREATE TEMP TABLE ... AS SELECT. Buggy shell stores 'CREATE TEMP TABLE' in the temp schema, so the GLOB query returns a row (clean: none) and ALTER fails/rename differs.
