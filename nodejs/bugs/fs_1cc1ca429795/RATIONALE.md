# Rationale

Bug: `validateOffsetLengthRead` (lib/internal/fs/utils.js) used a combined check `offset < 0 || offset >= bufferLength`, so a valid offset equal to the buffer length (e.g. zero-length reads at the end) was rejected, and error messages for negative offset/length were misleading (`>= 0 && <= N`).

Change (single hunk, corresponds to the single implementation hunk of the fix, re-expressed with the current `ERR_OUT_OF_RANGE.HideStackFramesError`): the separate `offset < 0` / `length < 0` / `offset + length > bufferLength` checks are merged back into the old two checks with the old messages (`>= 0 && <= ${bufferLength}` for offset, `>= 0 && <= ${bufferLength - offset}` for length).

Failing test: parallel/test-fs-read-type, e.g. expected message `The value of "length" is out of range. It must be >= 0. Received -1` but got `... It must be >= 0 && <= 4. Received -1`. Failed on two runs.
