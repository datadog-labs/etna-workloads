# Adapted injection for HIR ty lowering: Validate `PointeeSized` bounds

Fix: https://github.com/rust-lang/rust/commit/82a02aefe07092c737c852daccebf49ca25507e3

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, fn `lower_bounds`.
Re-adds the early `continue` for `PointeeSized` bounds (the parent's `should_skip_sizedness_bound`),
inlined at the top of the `for hir_bound in hir_bounds` loop. This re-expresses the fix hunk
`@@ -476,10 +458,6 @@ ... for hir_bound in hir_bounds {` which removed
`if self.should_skip_sizedness_bound(hir_bound) { continue; }`. With it, PointeeSized bounds skip
the validation (generic args, assoc item constraints, const-ness checks) in `lower_poly_trait_ref`.
