# Adapted injection for Handle DropKind::ForLint in coroutines correctly

Fix: https://github.com/rust-lang/rust/commit/42d1a4c48bd2c914f30fc6e97f9a1beda0c97729

All changes in compiler/rustc_mir_build/src/builder/scope.rs.
1. build_scope_drops, `DropKind::ForLint` arm: moved the `if scope.moved_locals.contains(&local) { continue; }` check back before the `unwind_to` adjustment (`if storage_dead_on_unwind {...}`). Re-expresses fix hunks `@@ -1481,14 +1481,6 @@` / `@@ -1500,6 +1492,14 @@`. A moved local now skips the unwind_to advance, desyncing it in coroutines.
2. build_exit_tree (link exit drop tree to unwind tree): `DropKind::Storage | DropKind::ForLint` -> `DropKind::Storage`, and `DropKind::Value` -> `DropKind::Value | DropKind::ForLint`. Re-expresses fix hunks `@@ -1552,7 +1552,7 @@` (`DropKind::Storage | DropKind::ForLint =>`) and the following one (`DropKind::Value | DropKind::ForLint` -> `DropKind::Value`).
