# Adapted injection for Always inline functions signatures containing `f16` or `f128`

Fix: https://github.com/rust-lang/rust/commit/5d818914af2760972943db448d2a08de27900c96

# Rationale
File: compiler/rustc_mir_transform/src/cross_crate_inline.rs, fn `cross_crate_inlinable`.
Removed the loop over `tcx.fn_sig(def_id)` inputs/output that returns true when a type is `f16`/`f128`.
Re-expresses fix hunk `@@ -50,6 +50,16 @@ fn cross_crate_inlinable(...)` (adds `let sig = tcx.fn_sig(def_id).instantiate_identity(); ... if ty == &tcx.types.f16 || ty == &tcx.types.f128 { return true; }`).
