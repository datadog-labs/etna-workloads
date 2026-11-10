# Re-introduced bug
`process.ref()`/`process.unref()` stopped honouring the documented `Symbol.for('nodejs.ref')` / `Symbol.for('nodejs.unref')` keys; only the undocumented `node:ref`/`node:unref` symbols (and legacy `.ref()`/`.unref()`) are looked up. This was the state before the fix.

# Hunks
Single file, lib/internal/process/per_thread.js. In `ref()` and `unref()`, the lookup symbol is changed from `nodejs.ref`/`nodejs.unref` back to `node:ref`/`node:unref`. This corresponds to both hunks of the fix's per_thread.js change (which added the `nodejs.*` symbols ahead of the `node:*` ones). Today's code lazily caches the symbol and has no `node:*` fallback, so the fix is re-expressed as a symbol swap. Objects using `nodejs.ref` are then ignored.

# Failing test
parallel/test-process-ref-unref: `not ok` (stable over 2 runs). The failure is `actual: 0, expected: 1`, from the refCalled/unrefCalled assertions on the object that implements `Symbol.for('nodejs.ref')`.
