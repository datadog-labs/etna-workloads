# Adapted injection for Fix handling of const params defaults that ref `Self` & generalize diag

Fix: https://github.com/rust-lang/rust/commit/233a45c41ad689dfb7cd6249dcb4e7e3eda01971

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, `lower_trait_object_ty`.
Re-expresses fix hunk `@@ -365,8 +365,8 @@` : `-Ty::new_misc_error(tcx).into()` / `+param.to_error(tcx)`.
Restored the old behaviour: a defaulted generic param whose default mentions `Self` is lowered to a
type error even for const params (instead of a const error), which ICEs.
The diagnostic generalization (messages.ftl, errors.rs, errors.rs in hir_ty_lowering) is already in 1.99.1 and left as-is (it is not needed for the bug).
