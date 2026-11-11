# Adapted injection for Fix coroutine validation for mixed panic strategy

Fix: https://github.com/rust-lang/rust/commit/5161b22143bf9a726cfd69d19bef11552d0ed519

# Rationale
Hunk 1: compiler/rustc_mir_transform/src/shim.rs, make_shim (CoroutineDrop arm): removed `&abort_unwinding_calls::AbortUnwindingCalls` from the pm::run_passes list. Re-expresses fix hunk `@@ -74,11 +74,13 @@ make_shim` which added AbortUnwindingCalls + CriticalCallEdges to the passes run with validation (previously `&[]`).

Hunk 2: compiler/rustc_mir_transform/src/coroutine/drop.rs, create_coroutine_drop_shim: after computing drop_instance, set `body.source.instance = drop_instance` and run `pm::run_passes_no_validate(.., &[AbortUnwindingCalls], None)` at coroutine-build time (in the defining crate's panic strategy). Re-expresses the removed lines in fix hunk `@@ -1168,18 +1167,9 @@ fn create_coroutine_drop_shim` (`body.source.instance = drop_instance; pm::run_passes_no_validate(...AbortUnwindingCalls...)`). CriticalCallEdges was already moved/handled elsewhere, so only the abort pass is restored.
