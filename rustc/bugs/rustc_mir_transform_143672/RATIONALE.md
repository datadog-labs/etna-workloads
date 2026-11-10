# Adapted injection for fix box destructor generation

Fix: https://github.com/rust-lang/rust/commit/dad982633c935ae70fbc5f9b1c0f4f845606c551

All changes in compiler/rustc_mir_transform/src/elaborate_drop.rs (the fix is already present in 1.99.1 in a rewritten form; I restored the pre-fix shape).

1. `open_drop_for_adt`: re-expresses fix hunk `@@ -761,24 +761,36 @@`. Removed the `adt.has_dtor` empty-drop-ladder / span_bug handling for skipped contents (old: just `(self.succ, self.unwind, self.dropline)`), and restored the old `if adt.is_box() {...open_drop_for_box_contents} else if adt.has_dtor() {destructor_call_block}` structure, dropping the outer `drop_flag_test_block(destructor_block, ...)` wrapper (the `+ self.drop_flag_test_block(destructor_block, contents_drop.0, contents_drop.1)` line).
2. `destructor_call_block_sync`: re-expresses fix hunk `@@ -982,12 +994,7 @@` (the removed `clear_drop_flag(block_start, ..Shallow)` + `drop_flag_test_block(destructor_block, succ, unwind)`). The old code cleared the shallow drop flags at block start and wrapped in a flag test inside the sync block builder. `clear_drop_flag` no longer exists, so it's done via `patch().add_assign` over `drop_flags_for(path, Shallow)`.
The async hunk (`@@ -1002,13 +1009,7 @@`, build_async_drop path) was not reverted.
