# Rationale

55.2.0 still contained the fix verbatim, so the hunks of `fix.patch` to
`datafusion/core/src/execution/context/mod.rs` were reversed directly.

- `create_memory_table`: removed both `Self::ensure_unique_column_names(input.schema())?`
  calls (the `(false, true, Ok(_))` replace arm and the `(_, _, Err(_))` arm).
- `create_view`: removed both calls and restored the old order in the
  or-replace arm (`deregister_table` before `apply_type_coercion`).
- Removed the `ensure_unique_column_names` helper and the now-unused
  `SchemaError` / `schema_err` imports.

Effect: CTAS, CREATE VIEW and SELECT INTO with duplicate unqualified output
names (e.g. a self join) succeed and register an unreadable object.

Oracle: `ddl.slt` fails on all 3 new statements (CTAS, CREATE VIEW,
SELECT INTO), each "expected to fail, but actually succeed".
