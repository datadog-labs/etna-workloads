# Re-introduced bug: zlib leaks on destroy (fix 8a02d941b6)

**Bug:** Destroying a zlib stream (`stream.destroy()`) did not close/free the native handle (`_handle` stayed set), so the zlib context leaked until close was triggered some other way. Also, if the stream was closed inside a `'data'` handler, `processCallback` kept going and continued processing/allocating after destruction.

**Hunks (all in lib/zlib.js; the class is now `ZlibBase`):**
1. Removed `ZlibBase.prototype._destroy` (calls `_close(this)`), corresponding to the fix's added `Zlib.prototype._destroy`. Without it destroy() never releases the handle.
2. Removed the `if (self.destroyed) { this.cb(); return; }` check in `processCallback` after `self.push(out)`, corresponding to the fix's added `if (self.destroyed) return;` check in the same place.

**Failing test:** `parallel/test-zlib-destroy` fails (not ok): AssertionError, `ts._handle` strictly-equal to null expected, but the handle object is still present. `test-zlib-close-in-ondata` still passes (stable across two runs).
