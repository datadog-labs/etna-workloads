# Adapted injection for diagnostics: suggest type annotation for closure params on HRTB FnOnce mismatch

Fix: https://github.com/rust-lang/rust/commit/a00bdacb0a83c006f2a4b804cec2cf1bb16a9662

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/infer/nice_region_error/placeholder_error.rs, fn `report_trait_placeholder_mismatch`'s tail (before `err`).
Removed the whole block `if self.tcx().is_fn_trait(trait_def_id) { ... err.multipart_suggestion(...) }` plus its now-unused imports (Applicability, hir, IsSuggestable). This re-expresses fix hunk `@@ -379,6 +380,50 @@ impl<'tcx> NiceRegionError<'_, 'tcx>` which added the closure-parameter type annotation suggestion; without it the parent behaviour (no suggestion) returns. Also the import hunk `@@ -1,13 +1,14 @@`.
