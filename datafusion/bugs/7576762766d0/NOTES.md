repro.sql writes a two-row CSV (k=1,v=16777217; k=2,v=16777216) with COPY and reads it back through an
external table declared `WITH ORDER (v DESC, k DESC)`. It then runs
`SELECT k, cast(v as float) v_ ... ORDER BY v_ DESC, k DESC`, followed by the EXPLAIN for the same query.

CAST(int AS FLOAT) maps both v values to 16777216.0, so it is not injective.
- df-clean: keeps a SortExec and returns k=2 then k=1, which is correct.
- df-buggy: `check_bigger_cast` wrongly treats Int32->Float32 as order-preserving. The SortExec is dropped and the rows come back as k=1 then k=2, which is wrong. The EXPLAIN plan differs as well.
