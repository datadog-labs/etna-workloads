# Re-introduced bug: share() drop-newest lets the buffer grow past the limit

**Bug.** With `backpressure: 'drop-newest'`, once the shared buffer reached its limit, `#waitForBufferSpace()` told the caller to pull anyway (`true`), so the upstream result was buffered and the buffer grew beyond its limit instead of discarding the newest results.

**Change (lib/internal/streams/iter/share.js).** In `#waitForBufferSpace()`, the `'drop-newest'` case returns `true` instead of `false`. This matches the fix's hunk `return true` -> `return false`. The `shouldBuffer`/`discard` plumbing from the fix's other hunks is still in the code, but it never discards now, because `shouldBuffer` is always true. That is the pre-fix behaviour.

**Failing test.** `parallel/test-stream-iter-share-from` fails on `testShareDropNewest`, which asserts that `shared.bufferSize` is 2. The output shows `actual: true, expected: false` for the assertion. The failure was the same on two runs.
