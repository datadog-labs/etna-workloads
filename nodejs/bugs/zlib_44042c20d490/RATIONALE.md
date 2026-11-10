# Zstd ArrayBuffer dictionary bug

**Bug:** `zlib.Zstd` only honoured `options.dictionary` when it was an ArrayBufferView. An `ArrayBuffer`/`SharedArrayBuffer` dictionary was silently ignored (passed as `undefined`), so compression ran without the dictionary.

**Hunks (all in lib/zlib.js):**
1. In the `Zstd` constructor, the normalisation block (`isAnyArrayBuffer` -> `new Uint8Array(dictionary)`, otherwise throw) is replaced by the original `opts?.dictionary && isArrayBufferView(opts.dictionary) ? opts.dictionary : undefined`. This corresponds to the fix's constructor hunk and to its change to the `handle.init` argument. The release also throws ERR_INVALID_ARG_TYPE for invalid types, and this change drops that too, which matches the pre-fix code.
2. The `Uint8Array` primordial import is removed (fix hunk 1), since nothing uses it now.

**Failing test:** parallel/test-zlib-zstd-dictionary reports `not ok`. The ArrayBuffer dictionary produces a different compressed length than the baseline, so the `assert.strictEqual(... .length, baseline)` check fails. I ran it twice and it failed both times.
