# Re-introduced bug: partial writes in fs.promises.writeFile with iterables

**Bug.** When `writeFile` consumes a (async) iterable, each chunk was written with a single
`write()` call and the returned `bytesWritten` was ignored. If a chunk is larger than one write
can handle, the remainder is silently dropped and the file is truncated.

**Change (lib/internal/fs/promises.js, `writeFileHandle`, iterable branch).** This corresponds to
the single implementation hunk of the fix. The fix's `while (remaining > 0)` loop, which tracked
`bytesWritten` and advanced the offset, is replaced by one
`write(filehandle, toWrite, undefined, MathMin(kWriteFileMaxChunkSize, toWrite.byteLength))` call
followed by `checkAborted`. A plain reversal does not fail, because a single full-length write
succeeds for the 6 MB test buffer. This version keeps today's chunk cap
(`kWriteFileMaxChunkSize`), so a chunk larger than the cap is written only up to the cap and the
rest is lost, as in the original partial-write defect.

**Failing test.** `parallel/test-fs-promises-writefile` fails (`not ok`) in `doWriteAsyncLargeIterable`
with an `assert.deepStrictEqual` mismatch: the actual content ('dogs running...') is shorter than
the expected `'dogs running'.repeat(512 * 1024)`. It failed on both runs.
