# Adapted injection for Do not ICE on unmet trait alias bounds

Fix: https://github.com/rust-lang/rust/commit/540bd986aac6f50363848f37ab1bb9e6eb408170

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/adjust_fulfillment_errors.rs, fn `blame_specific_part_of_expr_corresponding_to_generic_param`'s parent-obligation helper (the one computing `impl_trait_self_ref`).

Re-expresses fix hunk `@@ -477,12 +477,17 @@`: the fix added an `is_trait_alias(obligation.impl_def_id)` branch building an identity-substs TraitRef. I removed that branch, restoring the old code that only calls `impl_opt_trait_ref(...)` and returns `Err(expr)` when absent. For a trait alias this means no progress is made and the later code ICEs/misbehaves (the old behaviour).
