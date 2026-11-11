# Adapted injection for move subtyper change reveal_all

Fix: https://github.com/rust-lang/rust/commit/3088c4b0466085a81f83fbe3a10822fac75591b5

# Rationale
compiler/rustc_mir_transform/src/lib.rs: `run_analysis_cleanup_passes` / `run_runtime_lowering_passes`.
Re-expresses fix hunks `@@ -467,7 +467,6 @@ run_analysis_to_runtime_passes` (removed `&add_subtyping_projections::Subtyper` from analysis cleanup passes) and `@@ -483,6 +482,7 @@` (added it after RevealAll, "calling this after reveal_all ensures that we don't deal with opaque types"). Reverted: Subtyper now runs in analysis cleanup (before PostAnalysisNormalize, which is the 1.99.1 successor of RevealAll), and is removed from runtime lowering.
Other fix hunks (deref-temp skip, super_place/super_constant in reveal_all) are kept as is; they are not needed to restore the bug.
