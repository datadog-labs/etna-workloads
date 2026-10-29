Reproducer (`repro.sql`): a correlated scalar subquery sums over a UNION ALL view, which SQLite
queries via an automatic index on a co-routine subquery. The two rows with x='aaa' need distinct
index keys.

The fix appends a counter to each key, by turning OP_Rowid into OP_AddImm. The injected bug turns
it into OP_Null instead, so the keys collide and one row is lost.

Clean shell: `8.0`. Buggy shell: `4.0`.
