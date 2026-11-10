# Re-introduced bug: pooled Buffer ArrayBuffer can be transferred

Bug: `markAsUntransferable()` only set the private untransferable symbol, which postMessage honours. It never set a V8 detach key on the ArrayBuffer, so `buffer.buffer.transfer()` (and structuredClone-style detach paths) succeeded on the shared Buffer pool and detached it. Also the pool was not recreated after snapshot deserialization.

Hunks (all in lib/, re-expressed for today's code):
- lib/internal/buffer.js: removed `kDetachKey`, the `isArrayBuffer(obj)` branch calling `setDetachKey`, and the `setDetachKey` binding import (fix hunks 2-4 of internal/buffer.js). Also removed the `util/types` require and the now-unused `Symbol` primordial. Restores the old behaviour: no detach key set.
- lib/buffer.js: removed the `isBuildingSnapshot`/`addDeserializeCallback` import and the deserialize callback that recreates the pool (fix hunks in lib/buffer.js).
- src/node_buffer.cc: left unchanged; the native `setDetachKey` binding is just unused (harmless).

Failing tests (stable over 2 runs):
- parallel/test-buffer-pool-untransferable: `a.buffer.transfer()` no longer throws TypeError.
- parallel/test-bootstrap-modules: `NativeModule util/types` is no longer loaded before pre-exec, so the expected module list mismatches.
