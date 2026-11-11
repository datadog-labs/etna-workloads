# Adapted injection for Fix multi-crate crash if dependency has enabled AsyncDrop

Fix: https://github.com/rust-lang/rust/commit/db6ee18fd084381100899129cda2cfd050b77045

# Rationale
File: compiler/rustc_mir_transform/src/elaborate_drop.rs, fn `check_if_can_async_drop`.
Re-expresses fix hunk `@@ -452,6 +449,46 @@ where` (the new `check_if_can_async_drop`), whose key lines are
`let is_async_drop_feature_enabled = if self.tcx().features().async_drop() { true } else { ...!adt_def.did().is_local() && adt_def.async_destructor(..).is_some() }`.
Before the fix, only `features().async_drop()` gated async drop, so a crate without the feature still async-dropped types from a dependency (crash). I removed the dependency-crate fallback so the flag is just `self.tcx().features().async_drop()`.
The other fix hunks (call-site refactors, span_bug in check/mod.rs) are not needed for the behaviour.
