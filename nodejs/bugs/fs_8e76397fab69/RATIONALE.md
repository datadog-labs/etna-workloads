# Rationale

Bug: fs.write/writeSync/promises FileHandle.write with a string did not validate the encoding against the data in the JS layer (e.g. `'abc'` with `'hex'`, odd length). The invalid input reached `binding.writeString()` and produced a poorer error / wrong behavior instead of `ERR_INVALID_ARG_VALUE` ("'encoding' is invalid for data of length 3").

Hunks (all removals of `validateEncoding`, matching the fix's additions):
- lib/fs.js import: removed `validateEncoding` (fix's import hunk).
- lib/fs.js `write()`: removed `validateEncoding(str, length)` (fix's `write` hunk; `const str = buffer` already existed in today's code).
- lib/fs.js `writeSync()`: removed `validateEncoding(buffer, length)` (fix's writeSync hunk).
- lib/internal/fs/promises.js: removed import and the call in `write()` (fix's promises hunks).

Failing tests: parallel/test-fs-write and parallel/test-fs-promises, with the assertion on `message: /'encoding' is invalid for data of length 3/` failing (the expected error is not thrown/rejected).
