# Adapted injection for fix: don't emit `E0711` if `staged_api` not enabled

Fix: https://github.com/rust-lang/rust/commit/be1a6db9f8978113021e3f1214ea66700a22fe9a

# Rationale
compiler/rustc_passes/src/lib_features.rs, fn `lib_features`: removed the early return
`if !tcx.features().staged_api() { return LibFeatures::default(); }`.
Re-expresses fix hunk `@@ -137,6 +137,12 @@ impl<'tcx> Visitor<'tcx> for LibFeatureCollector<'tcx>` which added that guard
("If `staged_api` is not enabled then we aren't allowed to define lib features"). Without it, lib features are collected without staged_api, yielding spurious E0711.
