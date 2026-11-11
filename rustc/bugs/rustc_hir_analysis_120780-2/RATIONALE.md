# Adapted injection for Support weak alias types as self type of inherent impls

Fix: https://github.com/rust-lang/rust/commit/8677d64c724e30453e321b8022fb6495dc0f4129

# Rationale
File: compiler/rustc_hir_analysis/src/coherence/inherent_impls.rs, `InherentCollect::check_item`.
1.99.1 has `self.tcx.peel_off_free_alias_tys(self_ty)` (successor of the fix's `peel_off_weak_aliases`).
Re-expresses fix hunk `@@ -144,6 +144,7 @@ ... let self_ty = peel_off_weak_aliases(self.tcx, self_ty);`:
the peel is removed (`let mut self_ty = self_ty;`), so a free/weak alias self type reaches the
`ty::Alias(Free)` arm (`bug!("unexpected impl self type")`) instead of being expanded to the nominal type.
