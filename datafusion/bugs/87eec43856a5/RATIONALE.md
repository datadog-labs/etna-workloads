# Rationale

All changes are in `datafusion/sql/src/expr/mod.rs`.

1. Removed `extract_root_and_access_chain` and its call in
   `sql_compound_field_access_to_expr`, which now again does
   `let mut root = self.sql_expr_to_logical_expr(root, ...)?`. This reverses the
   fix hunks that added the helper and its call. The leading identifier of
   `test1.struct_field[...]` is resolved alone as a column, not combined with the
   following dotted identifiers into a qualified column.
2. Restored the old `AccessExpr::Dot(expr)` arm: it plans the dotted expression
   as a column, then either rebinds `root` (when the relation equals
   `root.schema_name()`), errors with "table name mismatch", or treats it as a
   named field. This reverses the hunk that replaced it with string-literal-only
   handling. The arm is the original code, adapted only to the `Expr::Column` API.
3. Restored `Column` in the `datafusion_common` import (reverses the import hunk).

## Oracle failures

`struct.slt` fails with "Schema error: No field named test1. Valid fields are
test1.struct_field, ...". The cases that fail are the `test1.struct_field.substruct['subsubstruct']`
and `test1.struct_field['substruct']['subsubstruct']` queries added by the fix.
The existing `t_left.s['x']` query in the same file also fails with the same error.
