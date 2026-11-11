# Adapted injection for Check for generic parameter mismatches on trait functions.

Fix: https://github.com/rust-lang/rust/commit/6378fbc366ad552ee791bcac670e0f3939489ef7

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, fn `get_hir_param_info`.
Removed the `hir::Node::TraitItem(... TraitItemKind::Fn(sig, trait_fn))` match arm (Required/Provided).
Re-expresses fix hunk `@@ -2673,35 +2672,56 @@ ... fn get_hir_param_info`, which added the `hir::Node::TraitItem` arm
(`hir::TraitFn::Required(params) => (sig, generics, None, Some(params))`). Without it, trait fns return None
(as before the fix), so no generic-parameter-mismatch labels appear on trait function definitions.
Other hunks (FnParam enum etc.) are refactors already present/needed only for that arm.
