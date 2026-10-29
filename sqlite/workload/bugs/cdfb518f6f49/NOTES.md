repro.sql builds the bloom1-4.1 setup (expression index `t1(1 IS true,z)` plus forged sqlite_stat1 rows) and runs the 4.2 join query.
Clean shell returns `aa|bb|aa`. Buggy shell aborts with `Assertion iCol!=XN_EXPR failed` in sqlite3ExprCodeGetColumnOfTable, because the Bloom filter code reads expression-index columns as plain table columns.
