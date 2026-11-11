# Adapted injection for Collect fulfillment errors across impls

Fix: https://github.com/rust-lang/rust/commit/00b976a1381b301a74b4f97f041de9a6cc58dba1

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/mod.rs, fn `select_inherent_assoc_candidates` (the code moved from astconv/mod.rs).
Fix hunk `@@ -2261,9 +2261,9 @@` changed `fulfillment_errors = errors;` to `fulfillment_errors.append(&mut errors);`.
Reverted: `fulfillment_errors = errors;` so errors from earlier impls are overwritten and only the last impl's errors are reported.
