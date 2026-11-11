# Adapted injection for Erase lifetimes above ty::INNERMOST when probing ambiguous types

Fix: https://github.com/rust-lang/rust/commit/5eb0528483ddb7614578fe5ef4b1104047b10ce6

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `probe_traits_that_match_assoc_ty` (was astconv `probe_traits_that_match_assoc_ty` in the fix).
Fix hunk `@@ -2514,24 +2514,16 @@`: replaced `create_next_universe` + `replace_escaping_bound_vars_uncached(qself_ty, FnMutDelegate{regions: erased, types/consts: placeholders})` with `fold_regions(qself_ty, erased)` + `if value.has_escaping_bound_vars() { return false; }`.
Re-injected the old behaviour: removed the fold_regions/escaping-vars early return, restored the universe and the placeholder-replacing delegate (only escaping vars are replaced, so lifetimes above INNERMOST handled wrongly). Removed the now-unused `fold_regions` import.
