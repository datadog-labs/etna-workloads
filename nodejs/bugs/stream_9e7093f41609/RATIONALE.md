# Rationale

**Bug:** `Writable` did not validate `options.defaultEncoding`. Any truthy value (e.g. `'my invalid encoding'`) was accepted and stored silently, instead of throwing `ERR_UNKNOWN_ENCODING`. Falsy values fell back to `'utf8'`.

**Hunk (lib/internal/streams/writable.js, WritableState constructor):** corresponds to the single implementation hunk of the fix. The fix added `Buffer.isEncoding()` validation and a throw of `ERR_UNKNOWN_ENCODING`. In the current code this lives in an if/else chain setting `kDefaultUTF8Encoding` / `kDefaultEncodingValue`. I removed the `Buffer.isEncoding` branch and the throw, so any non-utf8 truthy value is stored as-is, and falsy values give utf8 (the pre-fix `options.defaultEncoding || 'utf8'` semantics).

**Failing test:** `parallel/test-stream-writable-decoded-encoding` fails with
`AssertionError [ERR_ASSERTION]: Missing expected exception.` at line 61 (the `assert.throws` for the invalid defaultEncoding). Failure is stable across runs.
