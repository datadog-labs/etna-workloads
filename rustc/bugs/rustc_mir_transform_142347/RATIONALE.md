# Adapted injection for Async drop - fix for StorageLive/StorageDead codegen for pinned async drop future

Fix: https://github.com/rust-lang/rust/commit/d6a9081612e55b4d755163ce54d94ea0a96e4a2b

# Rationale
One hunk: compiler/rustc_mir_transform/src/elaborate_drop.rs, `build_async_drop`.
In 1.99.1 the code was rewritten: the unwind and dropline paths get intermediate blocks (`dropline_with_dead`, `unwind_with_dead`) that begin with `StorageDead(fut)`. I replaced them with the raw `dropline` / `unwind`, so those paths no longer emit StorageDead(fut).
This re-expresses the fix hunk `@@ -390,6 +390,20 @@` in elaborate_drop.rs ("StorageDead(fut) in unwind block (at the begin)" / "in dropline block (at the begin)"), which added those StorageDeads.
The coroutine/drop.rs hunks (StorageDead of the pinned future in build_poll_switch) no longer exist in 1.99.1 and were not re-injected.
