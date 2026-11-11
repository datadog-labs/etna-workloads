# Adapted injection for Suggest typos when trait path expression is typod

Fix: https://github.com/rust-lang/rust/commit/4486a19007f3fe9387eb5c1527b8d045354f316f

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs (lint.rs code moved here in 1.99.1), in the bare-trait-object error path.
Removed the call `self.maybe_suggest_typoed_method(hir_id, poly_trait_ref.trait_ref.trait_def_id(), &mut diag)`.
This re-expresses fix hunk `@@ -86,7 +88,12 @@ impl<'tcx> dyn HirTyLowerer` which added `self.maybe_suggest_typoed_method(self_ty, ..., &mut diag);`.
The function itself is kept (with #[allow(dead_code)]) so the build is warning-free; without the call, no typo suggestion is emitted.
