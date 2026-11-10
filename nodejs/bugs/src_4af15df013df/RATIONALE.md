# Re-introduced bug (nodejs/node 4af15df)

Bug: fs read/readSync/write/writeSync and the promises read/write validated `offset` with
`validateInteger(offset, 'offset')` (no minimum), so a negative offset passed JS validation and
reached C++, hitting a CHECK abort (process crash) instead of throwing ERR_OUT_OF_RANGE.

Hunks:
- lib/fs.js (4 sites: read, readSync, write, writeSync) and lib/internal/fs/promises.js (read, write):
  removed the `0` minimum argument from `validateInteger(offset, 'offset', 0)`, reverting the fix's
  corresponding hunks.
- The fix's utils.js hunk (`length < 0` check in validateOffsetLengthWrite) is already present in
  today's code (it also has validateInt32 length >= 0 afterwards), so it is left untouched.

Failing test: parallel/test-fs-write-negativeoffset: `write(fd, Buffer.alloc(0), -1, cb)` no longer
throws ERR_OUT_OF_RANGE; process aborts (exitcode -6). parallel/test-fs-read-type still passes.
