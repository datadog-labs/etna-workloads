# Adapted injection for use old ctx if has same expand environment during decode span

Fix: https://github.com/rust-lang/rust/commit/07481b9e90df0860519043b54e07529003e74814

# Hunk: compiler/rustc_span/src/hygiene.rs, `decode_syntax_context`
Fix hunk: `@@ -1413,6 +1413,14 @@ pub fn decode_syntax_context...` added a check that reuses the existing
(old) context data when `outer_expn`/`outer_transparency`/`parent` match the decoded data
(`ctxt_data = old.clone()`).
In 1.99.1 contexts are deduplicated through `syntax_context_map` in `alloc_ctxt`, so reuse of the
old ctxt happens there. To restore the bug (old ctxt with same expand environment is not reused
during decode), the decode path now removes the key from `syntax_context_map` before `alloc_ctxt`,
forcing a fresh duplicate ctxt for an already existing one.
