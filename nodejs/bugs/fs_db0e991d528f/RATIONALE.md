# Re-introduced bug: fs ReadStream custom Buffer pool

**Bug.** `fs.ReadStream` read into a shared, module-level `Buffer.allocUnsafe` pool and pushed
slices of it. Consumers got views onto a shared ArrayBuffer (problematic for Workers/transfer, and
for crypto streams like CCM that require exact buffers; issue #31733).

**Change (lib/internal/fs/streams.js)**
- Hunk 1 (re-adds `kMinPoolSpace`, `pool`, `poolFragments`, `allocNewPool`, `roundUpToMultipleOf8`):
  reverses the fix's first hunk, which removed the pool machinery.
- Hunk 2 (`ReadStream.prototype._read`): reverses the second hunk, restoring the pool-based read
  (reserve from pool, read into pool at `pool.used`, push `thisPool.slice(...)`, pool rewind/fragments,
  advance `this.pos` by `toRead` up front) instead of per-read `Buffer.allocUnsafeSlow(n)`.
  Adapted to today's code (which updates `pos` after the read); the old behaviour is restored.

**Failing test.** `parallel/test-crypto-authenticated-stream` -> `not ok` (stable over repeated runs);
the fstream variant yields pooled slices, so the authenticated-stream output/behaviour mismatches.
