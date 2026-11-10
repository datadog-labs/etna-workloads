# Re-introduced bug: http2 origin name wrong when servername is empty

**Bug:** `initializeTLSOptions` only defaulted `options.servername` when it was `undefined`. With `servername: ''`, the empty string was kept, so the TLS socket had no usable SNI/servername and the origin set / authority were computed from the wrong name (issue #39919).

**Hunk (lib/internal/http2/core.js, `initializeTLSOptions`):** corresponds to the single implementation hunk of the fix. The fix changed `options.servername === undefined` to `!options.servername`. I reverted that line to `options.servername === undefined`; the surrounding code is at a different line number today but is otherwise unchanged.

**Failing test:** `parallel/test-http2-create-client-secure-session` fails (`not ok`) with `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal`. It failed in 2 of 2 runs. The test file was not modified; the failure comes from its `{ servername: '' }` case (the case the fix added upstream, already present in this release).
