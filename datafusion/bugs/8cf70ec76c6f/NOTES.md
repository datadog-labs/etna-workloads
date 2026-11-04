repro.sql runs two UNION ALL queries (copied from the fix's union.slt additions) where non-first SELECTs
have duplicate unaliased literals (`SELECT name, 2, 2`, `SELECT 2, 0, 0`).
df-clean aliases them from the left side's schema and returns rows; df-buggy fails planning with
"Projections require unique expression names ...".
