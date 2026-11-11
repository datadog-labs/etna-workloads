# Adapted injection for check if redundant args spans belong to the same context

Fix: https://github.com/rust-lang/rust/commit/2c31b0deb13d9d49ea4b651b81765b9acb446d5a

File: compiler/rustc_hir_analysis/src/diagnostics/wrong_number_of_generic_args.rs (moved from errors/), in the fn computing span_redundant_type_or_const_args (suggestion for removing redundant args).
Removed the guard re-expressing fix hunk `@@ -988,6 +988,9 @@`:
`if !span_lo_redundant_type_or_const_args.eq_ctxt(span_hi_redundant_type_or_const_args) { return; }`
Without it, spans from different syntax contexts get joined (macro case, issue 149559).
