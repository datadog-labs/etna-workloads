# Rationale

Bug: `tls.connect()` with a non-function `options.checkServerIdentity` (undefined, null, 1, true) threw an internal assertion error (ERR_INTERNAL_ASSERTION) instead of a user-facing `ERR_INVALID_ARG_TYPE` TypeError.

Change (one hunk, lib/internal/tls/wrap.js in `connect()`; the file was `lib/_tls_wrap.js` at fix time): replaced
`validateFunction(options.checkServerIdentity, 'options.checkServerIdentity');` with
`assert(typeof options.checkServerIdentity === 'function');`. This corresponds to the fix's only implementation hunk, reversed, and restores the internal assert behaviour.

Failing test: parallel/test-tls-basic-validations — expected code `ERR_INVALID_ARG_TYPE`, got `ERR_INTERNAL_ASSERTION`. Stable over two runs.
