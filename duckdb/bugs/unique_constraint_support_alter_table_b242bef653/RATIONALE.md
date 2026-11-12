# Rationale
Hunk: src/parser/peg/transformer/transform_alter.cpp, TransformAddColumnEntry: the branch for UNIQUE column constraints no longer sets `add_column_constraints.add_unique = true`.
Traces to the fix's hunk `else if (UniqueConstraint) { add_unique = true; }`. Without it the follow-up ALTER ... ADD UNIQUE is never generated, so UNIQUE is silently dropped (pre-fix behaviour) and the duplicate insert of 5 succeeds.

Oracle: test/sql/alter/add_col/test_add_col_unique.test should fail at `INSERT INTO t VALUES (3, 5)` (expected a Constraint Error, none raised). See etna-check output below.

```
FAIL     test/sql/alter/add_col/test_add_col_unique.test
         Query unexpectedly succeeded! (test/sql/alter/add_col/test_add_col_unique.test:18)!
         INSERT INTO t VALUES (3, 5);
1 of 1 oracle units fail
```
