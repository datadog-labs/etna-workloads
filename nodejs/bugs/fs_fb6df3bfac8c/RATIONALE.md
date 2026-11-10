# Re-introduced bug (fix fb6df3bf, "fs: validate the input data to be of expected types")

Bug: fs write APIs did not validate non-string/non-ArrayBufferView data; it was coerced with
`'' + data` / `+= ''`, so `undefined` was written as the string "undefined" instead of throwing ERR_INVALID_ARG_TYPE.

Hunks (all re-expressed for today's code; `validateStringAfterArrayBufferView` stays defined/exported, just unused):
- lib/fs.js `write()` string path: replaced `validateStringAfterArrayBufferView(buffer,'buffer')` with `if (typeof buffer !== 'string') buffer += ''` (fix hunk in write()).
- lib/fs.js `writeSync()` string path: same replacement (fix hunk in writeSync()).
- lib/fs.js `writeFile()` and `writeFileSync()`: dropped validation, `Buffer.from('' + data, encoding)` (fix hunks in writeFile/writeFileSync).
- lib/internal/fs/promises.js `write()` : coercion `buffer += ''` instead of validation; `writeFile()`: `Buffer.from('' + data, ...)` (fix hunks in promises.js).

Failing tests (stable over 2 runs): test-fs-append-file, test-fs-append-file-sync, test-fs-buffertype-writesync,
test-fs-promises-file-handle-write, test-fs-write — assert.throws/rejects expecting ERR_INVALID_ARG_TYPE
fail with "Missing expected exception" since the call now succeeds.
