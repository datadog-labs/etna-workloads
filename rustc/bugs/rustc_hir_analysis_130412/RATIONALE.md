# Adapted injection for Don't ICE when RPITIT captures more method args than trait definition

Fix: https://github.com/rust-lang/rust/commit/1e9fa7eb79072274fbd741f09e9444249e1d4ff0

# Hunk
compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, `RemapHiddenTyRegions::try_fold_region`:
changed `region.opt_param_def_id(self.tcx, self.impl_m_def_id)` back to
`region.opt_param_def_id(self.tcx, self.tcx.parent(self.def_id))`.
Re-expresses fix hunk `@@ -899,7 +904,7 @@ impl ... RemapHiddenTyRegions`:
`-let guar = match region.opt_param_def_id(self.tcx, self.tcx.parent(self.def_id))` /
`+... self.impl_m_def_id`. The old code looks up the region's generics in the trait method's
parent (wrong item), so an RPITIT capturing an impl-method early lifetime ICEs ("expected lifetime parameter").
Other hunks (field rename, diagnostics message) are not behavioural and were left as is.
