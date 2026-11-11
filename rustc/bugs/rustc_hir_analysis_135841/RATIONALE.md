# Adapted injection for Reject `impl Trait` bounds in various places where we unconditionally warned since 1.0

Fix: https://github.com/rust-lang/rust/commit/c294da3310301027dfa304b270c5d0ab78c2b851

# Rationale
One hunk: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, `require_bound_to_relax_default_trait` (the 1.99.1 successor of the old `?Trait`-not-`?Sized` check): `self.dcx().span_err(` -> `self.dcx().span_warn(`.
Re-expresses the fix hunk `@@ -102,8 +102,8 @@` which changed `self.dcx().span_warn(unbound.span, "relaxing a default bound only does something for `?Sized`...` to `span_err`. The old message text no longer exists in 1.99.1; the check was moved and reworded, so only the severity is reverted (non-Sized `?Trait` bounds are only warned about again).
