# Adapted injection for Account for `!` arm in tail `match` expr

Fix: https://github.com/rust-lang/rust/commit/8221f9c837f46461d2dd6f29a4468b3a0ee4b508

# Rationale
File: compiler/rustc_hir_typeck/src/_match.rs, `check_expr_match` / removed `explain_never_type_coerced_to_unit`.
Re-expresses fix hunks `@@ -139,7 +139,9 @@` (closure now calls `explain_never_type_coerced_to_unit(...)`) and `@@ -177,6 +179,38 @@` (the new fn adding the "this expression is of type `!`, but it is coerced to ..." label and tail suggestion for a `!`-typed tail arm). Reverted to the parent: closure calls only `suggest_removing_semicolon_for_coerce`, helper removed.
The other fix hunks (moving suggest_missing_semicolon out of suggest_mismatched_types_on_tail) are a refactor needed only by the new helper and were left alone.
