# Rationale

Fix: qualified wildcards (`PUBLIC.t1.*`) must normalize the qualifier via `object_name_to_table_reference` (honouring `enable_ident_normalization`). Pre-fix code did not normalize, so upper-case qualifiers failed to match.

## Changes
- `datafusion/sql/src/select.rs` (`SelectItem::QualifiedWildcard`): reverses the select.rs hunk. The old code was `idents_to_table_reference(object_name.0, false)` (normalization hard-disabled); in 55.2.0 the equivalent is `object_name_to_table_reference(object_name, false)`, which wraps `idents_to_table_reference`.
- `datafusion/sql/src/expr/mod.rs` (`SQLExpr::QualifiedWildcard`): reverses the expr hunk, restoring `TableReference::from(object_name.to_string())` (no normalization, string re-parse), and re-adds the `TableReference` import.

## Oracle
`wildcard.slt` fails: `SELECT PUBLIC.t1.* FROM PUBLIC.t1` and `SELECT PUBLIC.t1.* FROM public.t1` error with "Invalid qualifier PUBLIC.t1".
