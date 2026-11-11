# Adapted injection for generalize hr alias: avoid unconstrainable infer vars

Fix: https://github.com/rust-lang/rust/commit/690d5aa417f5d8f8d6157e5a897df5d7dd2ef59a

# Rationale
File: compiler/rustc_infer/src/infer/relate/generalize.rs, `Generalizer::tys` (type-var case) and `Generalizer::consts` (unevaluated/infer const case).

Removed the blocks that, in the new solver inside an alias (`self.in_alias`), equate the freshly created generalized inference variable with the original one (`type_variables().equate(vid, new_var_id)` and `variable_table.union(vid, new_var_id)`).
Re-expresses fix.diff hunks `@@ -492,9 +498,30 @@ ... fn tys` (added "If we're in the new solver and create a new inference variable inside of an alias we eagerly constrain..." + `inner.type_variables().equate(vid, new_var_id)`) and `@@ -614,6 +641,15 @@` (added `variable_table.union(vid, new_var_id)`).
Without them, `?y_new` stays unconstrained -> ambiguity (hr-alias-universe-lowering-ambiguity fails).
The `!self.in_alias` guard in `generalize_alias_ty` was left in place.
