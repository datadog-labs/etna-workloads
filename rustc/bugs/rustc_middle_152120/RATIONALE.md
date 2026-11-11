# Adapted injection for Don't ICE on layout error in vtable computation

Fix: https://github.com/rust-lang/rust/commit/e098327271327f86fb6aac22e64136f4a3268d31

# Hunk: compiler/rustc_middle/src/ty/vtable.rs, `vtable_allocation_provider`
Fix hunk `@@ -99,9 +99,10 @@ pub(super) fn vtable_allocation_provider`: replaced `.expect("failed to build vtable representation")` on `layout_of` with a match that emits a fatal diagnostic on `Err`.
In 1.99.1 the match used `tcx.dcx().fatal(e.to_string())`; I restored the old `.expect(...)`, so a layout error (e.g. `[u8; usize::MAX]`) ICEs instead of giving a clean error.
