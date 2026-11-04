# Rationale

Fix hunk reversed: `get_constraint_column_indices` (previously inline in `new_constraint_from_table_constraints`)
normalized constraint column identifiers via `self.ident_normalizer.normalize(ident.clone())`.
Before the fix, the raw `ident.value` was compared with the schema field names, with no normalization.

Change (datafusion/sql/src/statement.rs, `get_constraint_column_indices`): replaced the normalizer call with
`ident.value.clone()`. This is the pre-fix lookup (`*item == u.value`). The helper refactor and `&self` signature
already exist in 55.2.0 and are left alone; both PK and UNIQUE paths go through this one helper, as in the fix.

Oracle failure (ident_normalization.slt): with normalization enabled, `create table t(COLUMN_NAME TEXT NOT NULL,
constraint COLUMN_NAME_PK primary key (COLUMN_NAME))` and `create table t(cOlUmn_name ..., unique(COLUMN_NAME))`
fail with "Column for primary key / unique constraint not found in schema: COLUMN_NAME" (the schema field is
lowercased), and the subsequent drops fail because the tables don't exist.
