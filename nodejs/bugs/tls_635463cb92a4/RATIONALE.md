# Re-introduced CVE-2021-22939 (tls rejectUnauthorized: undefined)

**Bug:** `tls.connect({rejectUnauthorized: undefined})` was not normalised to the default `true`. The
option stayed `undefined`, so in `onConnectSecure` an unauthorized (e.g. expired) certificate was
accepted instead of destroying the socket.

The code now lives in `lib/internal/tls/wrap.js` (was `lib/_tls_wrap.js`).

**Hunks**
1. `onConnectSecure`: `if (options.rejectUnauthorized !== false)` -> `if (options.rejectUnauthorized)`
   (reverses fix hunk 1). With `undefined` the check is falsy, so the error is ignored.
2. `connect()`: removed `options.rejectUnauthorized = options.rejectUnauthorized !== false;` and its comment
   (reverses fix hunk 2), so `undefined` is stored in `kConnectOptions` un-normalised.

**Failing test:** `parallel/test-tls-client-reject` -> `not ok 1` (stable across 2 runs); the
`rejectUnauthorizedUndefined` case connects successfully, so `common.mustNotCall()` on the connect callback fails.
