# Rationale

Hunk: src/parser/peg/transformer/transform_alter.cpp, TransformAddColumnEntry.
Traces to the fix's hunk adding the `NotNullConstraint` branch that sets `is_not_null`
(today: `add_column_constraints.add_not_null = true`). The branch now does nothing, so
`ALTER TABLE t ADD COLUMN b INTEGER NOT NULL` silently drops NOT NULL (original bug #25401):
no SetNotNull follow-up is generated, so the NULL-filled column is accepted and NULL inserts succeed.

Oracle: test/sql/alter/add_col/test_add_col_not_null.test is expected to fail
(first `statement error` ALTER on non-empty table now succeeds). See etna-check output below.

## etna-check output
FAIL     test/sql/alter/add_col/test_add_col_not_null.test
         Query unexpectedly succeeded! (test/sql/alter/add_col/test_add_col_not_null.test:11)!
         ALTER TABLE t ADD COLUMN b INTEGER NOT NULL;
1 of 1 oracle units fail
