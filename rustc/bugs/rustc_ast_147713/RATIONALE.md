# Adapted injection for Retire ast::TyAliasWhereClauses.

Fix: https://github.com/rust-lang/rust/commit/15c91bf308acdaced24eecf73d3cfd3d8eaa2cb0

# Re-injection: stale `split` index for type-alias where clauses

1.99.1 already contains the fix (`after_where_clause: WhereClause`). I restored the old design's essential flaw: the after-clause predicates are merged into `generics.where_clause.predicates` and a positional `split` index records the boundary. `#[cfg]` stripping of where predicates (where_clause_attrs) later shrinks the Vec but not `split`, so `split_at(split)` panics (issue 138010).

- `rustc_ast/src/ast.rs` `TyAlias`: added `split: usize`. Re-expresses fix hunk `@@ -3636,49 +3636,26 @@` (removal of `TyAliasWhereClauses { ..., split }`).
- `rustc_parse/src/parser/item.rs` `parse_type_alias`: after-predicates are drained into `generics.where_clause.predicates`, `split` recorded. Re-expresses `@@ -1041,40 +1041,19 @@` (`predicates.extend(after_where_clause.predicates)`, `split: before_where_clause.predicates.len()`).
- `rustc_ast_lowering/src/item.rs` `add_ty_alias_where_clause`: dropped the `extend_from_slice` (already merged). Re-expresses `@@ -36,20 +36,18 @@`.
- `rustc_ast_passes/src/ast_validation.rs` `check_type_alias_where_clause_location`: uses `predicates.split_at(ty_alias.split)`. Re-expresses `@@ -145,25 +145,24 @@` (`split_at(ty_alias.where_clauses.split)`).
- `rustc_ast_pretty/src/pprust/state/item.rs` `print_associated_type` (+3 callers, `print_where_clause_parts` restored): splits predicates by `split`. Re-expresses `@@ -127,14 +127,12 @@` and `@@ -759,14 +757,7 @@`.
- `rustc_builtin_macros/src/deriving/generic/mod.rs`: `split: 0` in the constructor (`@@ -610,7 +610,7 @@`).
