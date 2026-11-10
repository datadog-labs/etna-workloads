# Adapted injection for Validate and test `-Zmir-enable-passes`

Fix: https://github.com/rust-lang/rust/commit/94371d5a8cf3c0480a744e4727837e9d7b2281b0

# Rationale
File: compiler/rustc_mir_transform/src/pass_manager.rs, fn run_passes_inner.
Removed the block computing `named_passes` and emitting `UnknownPassName` warnings (plus the ValidPassNames note) for names in `-Zmir-enable-passes` not in `PASS_NAMES`.
Re-expresses fix hunk `@@ -198,13 +198,29 @@ fn run_passes_inner` which added
`for &name in named_passes.difference(&known_passes) { tcx.dcx().emit_warn(errors::UnknownPassName { name }); }`.
Before the fix, unknown pass names were silently ignored. (The `diagnostics` import becomes unused, a harmless warning.)
