# Adapted injection for Tweak incorrect assoc item note

Fix: https://github.com/rust-lang/rust/commit/1af153cdb91c3d862daa5d1382496055fef678c6

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn report_no_match_method_error.
Fix hunk `@@ -1175,10 +1175,24 @@` added `has_self_assoc_type` and a branch `else if has_self_assoc_type { "associated function or constant" }`.
In 1.99.1 the final else already yields "associated function or constant", so I re-expressed the pre-fix behaviour: a `Self`-path QPath source (`Res::SelfTyAlias`) now yields the generic "associated item" wording again, instead of "associated function or constant".
