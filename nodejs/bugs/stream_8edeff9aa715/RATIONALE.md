# Rationale

**Bug:** `releaseWritingBuf()` in `lib/internal/streams/fast-utf8-stream.js` converted a
partial-write byte count `n` to a character count by decoding `Buffer.from(str).subarray(0, n)`.
When `n` split a multi-byte UTF-8 character, the truncated bytes decode to U+FFFD or a
partial char, so the character count was off: 3-byte chars (CJK) were silently dropped and
4-byte chars (emoji) left lone surrogates in the remaining buffer.

**Hunk (releaseWritingBuf):** corresponds to the fix's only implementation hunk in that function.
The release's version backs up over continuation bytes (`(buf[n] & 0xC0) === 0x80`) before decoding;
I replaced it with the pre-fix logic: if `Buffer.byteLength(str) !== n`, `n = Buffer.from(str).subarray(0, n).toString().length`
(no boundary backup). The full-write case keeps `n = writingBuf.length`, which is how the release handles it today.

The `_asyncDrainScheduled` typo hunk does not exist in today's code (already `#asyncDrainScheduled`), so nothing was changed there.

**Failing test:** `parallel/test-fastutf8stream-partial-write-utf8` fails (stable over 2 runs):
`actual: 'def', expected: '中def'` (3-byte char dropped after a 4-byte partial write).
