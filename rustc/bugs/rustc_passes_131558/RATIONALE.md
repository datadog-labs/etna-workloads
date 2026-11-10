# Adapted injection for fix: rust-lang/rust#47446

Fix: https://github.com/rust-lang/rust/commit/1696f534abe0655ee43ed57972a62d1cce42c233

# Rationale
File: compiler/rustc_passes/src/check_attr.rs, `check_attrs` call site of `check_mix_no_mangle_export` (the lint moved here from codegen_ssa in 1.99.1).
Removed the call `self.check_mix_no_mangle_export(hir_id, attrs);` (and added `#[allow(dead_code)]` on the fn).
This re-expresses the fix hunks in codegen_attrs.rs (`@@ -519,6 +519,8 @@` adding `mixed_export_name_no_mangle_lint_state.lint_if_mixed(tcx);`) and errors.rs/messages.ftl (the new `MixedExportNameAndNoMangle` UNUSED_ATTRIBUTES lint): pre-fix, no lint was emitted when #[export_name] and #[no_mangle] were combined.
