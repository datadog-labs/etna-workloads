# Rationale

## Change
`src/optimizer/topn_window_elimination.cpp`, `TopNWindowElimination::CanUseLateMaterialization`:
removed the block that sets `params.row_ids_may_have_duplicates = true` when the source join is INNER.
This traces to the fix's hunk adding that exact block. Without it the flag stays false, so `ConstructJoin`
builds the SEMI reconstruction join (as before the fix). A SEMI join emits each selected row ID at most once,
so duplicated row IDs from an inner join below the window lose their multiplicity.
(The other hunks — the parameter plumbing, struct field, and ConstructJoin's use of the flag — remain as inert
infrastructure; the flag is just never set.)

## Oracle result
```
FAIL     test/sql/optimizer/topn_window_elimination_multiplicity.test
         Wrong row count in query! (test/sql/optimizer/topn_window_elimination_multiplicity.test:22)!
         Expected 2 rows, but got 1 rows
1 of 1 oracle units fail
```
