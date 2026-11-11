# Adapted injection for Revert some `span_bug`s to `span_delayed_bug`.

Fix: https://github.com/rust-lang/rust/commit/edda2a7d3e7e541097285c03c0a8f68ad9b2fbc4

# Hunk: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, fn resolve_lifetime_ref (end)
Changed `span_delayed_bug` back to `span_bug` for "Could not resolve {:?} in scope".
Re-expresses fix hunk `@@ -1331,7 +1331,7 @@` (`-self.tcx.dcx().span_bug(` / `+self.tcx.dcx().span_delayed_bug(`).
The probe.rs hunk (HRTB non-lifetime bound vars) was not reapplied: that code no longer exists in 1.99.1.
