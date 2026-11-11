# Adapted injection for Detect (non-raw) borrows of null ZST pointers in CheckNull

Fix: https://github.com/rust-lang/rust/commit/b4641b2b3fd0616fa9597537f8fd954c34e6535f

# Rationale
File: compiler/rustc_mir_transform/src/check_null.rs, fn `insert_null_check`.
Re-expresses the hunk `@@ -42,30 +43,51 @@ fn insert_null_check` of fix.diff, which added
`match context { SharedBorrow | Borrow => unconditional check (true), _ => only if size_of != 0 }`.
I removed the borrow arm, so borrows of null ZST pointers go through the "pointee is not a ZST" path and are no longer flagged (the pre-fix behaviour). The `context` parameter is renamed `_context` (the fix's `context: PlaceContext` hunk), and the now-unused MutatingUseContext/NonMutatingUseContext imports are dropped (hunk 1 of the fix).
