# Adapted injection for Erase escaping late-bound regions when probing for ambiguous associated types

Fix: https://github.com/rust-lang/rust/commit/79ad7cca453468458a0ae63d091cbe6b23aa94a1

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, fn `probe_traits_that_match_assoc_ty` (the ambiguous-assoc-type candidate probe; moved from astconv/mod.rs).

Fix hunk `@@ -2396,13 +2396,24 @@` replaced `tcx.fold_regions(qself_ty, ...)` with replacing escaping bound vars (regions erased, types/consts -> placeholders) before `can_eq`. In 1.99.1 this is handled by an early `if value.has_escaping_bound_vars() { return false; }` after folding regions. I removed that guard, so a qself type with an escaping bound type var (`for<B> B::Item`) reaches `infcx.can_eq` unreplaced, which is the pre-fix behaviour.
