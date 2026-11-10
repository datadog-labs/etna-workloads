# Re-introduced bug: randomFillSync ignores the view's byteOffset

**Bug.** `crypto.randomFillSync()` given a typed array / Buffer that is a view into a larger
ArrayBuffer at a non-zero byteOffset (e.g. `Buffer.from(ab, 10)`) filled the wrong region:
the underlying `ArrayBuffer` was passed to the native code, so offset/size were applied
relative to the start of the ArrayBuffer, not the view. The view's own bytes stayed unchanged.

**Hunk.** `lib/internal/crypto/random.js`, in `randomFillSync`:
`randomFillSyncImpl(buf, offset, size)` -> `randomFillSyncImpl(buf.buffer || buf, offset, size)`.
This corresponds to the fix's single hunk (`buf.buffer || buf` -> `buf` in the `RandomBytesJob`
call). In the current release the sync path calls `randomFillSyncImpl` instead of constructing a
`RandomBytesJob`, so the same defect is re-expressed there. The native `RandomFillSync`
handles views correctly, so only the JS argument needed to change.

**Failing test.** `parallel/test-crypto-randomfillsync-regression` ("not ok" in TAP, on two runs):
the buffer contents are unchanged after `randomFillSync(buf)`, so `notStrictEqual(before, after)`
fails (the first 10 bytes of the ArrayBuffer were filled instead of the view's bytes).
