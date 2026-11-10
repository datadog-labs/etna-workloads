# Adapted injection for Use `resolutions(()).effective_visiblities` to avoid cycle errors

Fix: https://github.com/rust-lang/rust/commit/6a2bd5acd664e6bd118563ea9033245c624fec2e

Hunk: compiler/rustc_trait_selection/src/error_reporting/traits/mod.rs, report_dyn_incompatibility.
Replaced `tcx.resolutions(()).effective_visibilities.is_exported(def_id)` with `tcx.effective_visibilities(()).is_exported(def_id)`,
re-expressing fix hunk `@@ -132,7 +132,10 @@ pub fn report_object_safety_error` (`- tcx.effective_visibilities(()).is_exported(def_id)` / `+ tcx.resolutions(()).effective_visibilities...`) in reverse. Causes a query cycle during typeck.
