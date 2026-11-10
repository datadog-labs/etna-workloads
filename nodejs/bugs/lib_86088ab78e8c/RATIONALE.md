# Re-introduced bug: TextDecoder.decode() throws TypeError on a detached ArrayBuffer

**Bug.** Decoding a detached ArrayBuffer (or a view over one) made `new FastBuffer(...)` throw
`TypeError: Cannot perform Construct on a detached ArrayBuffer`. The fix catches it and treats the input as empty (`''`).

**Changes (lib/internal/encoding.js).** Upstream's `lazyBuffer().from(...)` calls are now in the shared helper `parseInput`.
1. `parseInput`, ArrayBuffer branch: removed `try/catch { return empty }` around `new FastBuffer(input)`. Corresponds to the fix's ICU and JS decoder hunks for `isAnyArrayBuffer`.
2. `parseInput`, ArrayBufferView branch: removed the try/catch around `new FastBuffer(input.buffer, ...)`. Corresponds to the JS decoder's `isArrayBufferView` hunk.
3. `decode()` UTF-8 fast path: `decodeUTF8(input, ...)` became `decodeUTF8(parseInput(input), ...)`. Today the fast path hands the raw input to C++, which already tolerates detached buffers. Before the fix every input went through the buffer conversion, so this restores that route and exposes the throw.

**Failing test.** `parallel/test-whatwg-encoding-custom-textdecoder` fails (not ok, run twice):
`TypeError: Cannot perform Construct on a detached ArrayBuffer at new FastBuffer ... at parseInput ... at TextDecoder.decode` (test line 208: the detached-buffer decode).
