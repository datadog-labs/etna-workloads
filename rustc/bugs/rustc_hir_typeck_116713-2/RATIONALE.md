# Adapted injection for Properly account for self ty in method disambiguation suggestion

Fix: https://github.com/rust-lang/rust/commit/5cc9216ff3552ac1f6b545860bc25f25cf6551df

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn `note_candidates_on_method_error` area (CandidateSource::Impl arm, call to `print_disambiguation_help`).

The fix hunks (`@@ -1322,7 +1322,7 @@` `rcvr_ty` -> `impl_ty`, and `@@ -3172,13 +3175,13 @@` `<{rcvr_ty} as ..>` -> `<{self_ty} as ..>`) made the impl-candidate suggestion use the correct self type, separate from the receiver type. In 1.99.1 this is done by building the trait ref with `.with_replaced_self_ty(self.tcx, rcvr_ty)`. I removed that call in the Impl arm, so the suggestion uses the impl's own self type (`T` for blanket impls) instead of the type at the call site. This brings back the wrong self type in the disambiguation suggestion. It is an approximation of the old bug, because the code was restructured.
