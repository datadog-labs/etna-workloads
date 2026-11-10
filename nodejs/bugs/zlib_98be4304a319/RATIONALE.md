# Rationale

**Bug:** `BrotliCompress/Decompress.flush(kind)` forwarded flush kinds outside the brotli operation range [0,3] (e.g. Z_FINISH=4, Z_BLOCK=5) to the native layer, which spins at 100% CPU.

**Change (lib/zlib.js, `ZlibBase.prototype.flush`):** The release no longer has the fix's explicit brotli check. It validates `kind` via `checkRangesOrGetDefault` using `FLUSH_BOUND[this._flushBoundIdx]`. This corresponds to the fix's added brotli-range check hunk (and the `_flushBoundIdx` hunk). I made the call use the generic zlib bounds `FLUSH_BOUND[FLUSH_BOUND_IDX_NORMAL]` (0..5) instead of the stream-specific bounds. Brotli streams then accept 4..5 and forward them natively, which is the pre-fix behaviour. Non-number kinds fall back to the default again, so they also don't throw.

**Failing test:** `parallel/test-zlib-brotli-flush-invalid-kind` fails with `AssertionError: Missing expected exception (RangeError)` (test line 61, kind Z_FINISH). The process then keeps spinning at 100% CPU and doesn't exit, so the runner reports a timeout failure.
