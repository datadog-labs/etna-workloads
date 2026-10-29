repro.sql: a REAL column holding 123, with an index on likely(a). Reading likely(a) through the index should give typeof 'real', same as a table scan.
Buggy shell: the index stores the value as an integer, so the INDEXED BY query prints 'integer' instead of 'real'. The clean shell prints 'real' for both queries.
