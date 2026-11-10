# Rationale

Bug: temporary UTF-8 buffers for `string` FFI arguments were cached per library owner and per argument index only, with no notion of call depth. When a native call is running (holding a pointer to the outer string buffer) and re-enters JS via a callback that makes another FFI call with a string argument, the inner call overwrites the same buffer, so the outer native code sees the inner string.

Changes (all in lib/internal/ffi/fast-api.js):
- `enterStringConversion`/`exitStringConversion`/`getStringConversionPointer`: correspond to the fix hunk adding depth-indexed buffers (`state.buffers[state.depth]`, depth++/--). Now enter no longer advances depth, and lookup always uses `buffers[0]`, so there is one slot per arg index again (old behaviour).
- `wrapWithRawPointerConversions`: corresponds to the fix hunk creating a per-wrapper `stringState`. It now takes the state from the shared per-owner `state` object (`state.stringState ??= ...`), so all wrappers of a library share buffers, as the old owner-level `kStringConversionBuffer` did.

Failing test: ffi/test-ffi-fast-buffer, subtest "fast FFI string buffers survive reentrant callbacks": assert.strictEqual actual: 0, expected: 1 (outer string was overwritten by 'inner string'). Stable across two runs.
