# Re-introduced bug: rmSync swallows errors

Before the fix, rmSync (rimraf) gave up silently on errors that were not retryable (e.g. EACCES in a read-only directory) instead of throwing them. The release has since moved rmSync into C++ (`RmSync` in `src/node_file.cc`), so the JS hunks of the fix (`_unlinkSync`/`_rmdirSync` in rimraf.js) no longer exist.

## Change
`src/node_file.cc`, `RmSync` retry loop: for an error that is neither success/ENOENT nor retryable (`!can_omit_error(error)`), `break` (which falls through to the code that throws the matching errno exception) became `return`, so the error is silently swallowed. This corresponds to the fix's new `else if (i === tries) throw err;` / `throw originalErr || err;` hunks: removing them is what made the old code return silently.

## Failing tests
`parallel/test-fs-rm` fails (stable across runs): the new `rmSync` on a file in a read-only directory expects `EACCES` to be thrown, but nothing is thrown (assertion "Missing expected exception", ERR_ASSERTION).
