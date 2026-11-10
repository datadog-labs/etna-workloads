# Bug
`assert.ok`/`assert()` decided whether a custom message was an Error with `instanceof Error`, which fails for errors created in another realm (e.g. `vm` contexts). Such errors were not thrown as-is; they were rejected as an invalid `message` argument type.

# Change
`lib/internal/assert/utils.js` (innerFail, where innerOk's message is processed; the code moved from `innerOk` in lib/assert.js): `isError(obj.message[0])` -> `obj.message[0] instanceof Error`. This corresponds to the fix hunk `message instanceof Error` -> `isError(message)` in lib/assert.js.

# Failing test
`parallel/test-assert` fails: expected message 'custom error' but got
`The "message" argument must be one of type string or function. Received an instance of SyntaxError` (ERR_INVALID_ARG_TYPE).
