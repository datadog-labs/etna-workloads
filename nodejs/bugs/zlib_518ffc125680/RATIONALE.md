# Re-introduced bug: zlib multiple `.flush()` calls coalesced (518ffc1256)

**Bug.** When `.write()` and `.flush()` are interleaved synchronously, a `.flush()` issued while another flush is still queued is merged into the pending one (strongest flag wins) and its callback is never called. The flush also ends up positioned after later writes, so it no longer affects only data written before it.

**Hunks (all in lib/zlib.js)**
- Removed `kFlushFlag` symbol and the `kFlushBuffers` table, restored the single shared `flushBuffer = Buffer.alloc(0)` (fix hunks 1 and 4). The old code identifies a flush chunk by identity rather than by a per-flag buffer.
- Restored `this._nextFlush = -1` in the `ZlibBase` constructor (fix hunk 2).
- `flush()`: restored the `else if (this._nextFlush !== -1)` branch that coalesces via `maxFlush` and drops the callback, and sets `_nextFlush` before writing `flushBuffer` (fix hunk 5).
- `_transform`: restored `chunk === flushBuffer` → `flushFlag = this._nextFlush; this._nextFlush = -1` (fix hunk 6).
- The `flushiness`/`maxFlush`/`kFlushFlagList` code is kept, since the release still uses it for `_finishFlushFlag`.

**Failing test.** `parallel/test-zlib-flush-write-sync-interleaved` fails (`Error: unexpected end of file`, plus uncalled flush callbacks). `test-zlib-write-after-flush` still passes.
