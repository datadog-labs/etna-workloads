# Rationale

## Changed hunk
`tree/src/networking.c` (`clientCommand`, `CLIENT TRACKING ON`): removed the
`if (options.tracking_bcast) { if (!checkPrefixCollisionsOrReply(...)) {zfree(prefix); return;} }`
block before `enableTracking(...)`.

This reverses the fix's `src/networking.c` hunk, which added exactly that call
(9.0.7 uses `options.tracking_bcast` instead of `options & CLIENT_TRACKING_BCAST`).
The `tracking.c`/`server.h` hunks (the function itself) were left in place, since
the function now exists as unused-but-declared code and reversing only the call site
restores the pre-fix behaviour: overlapping BCAST prefixes are accepted silently.

## Oracle failures
- `BCAST with prefix collisions throw errors`: gets `OK` instead of `ERR Prefix 'FOOBAR'...`.
- `Tracking info is correct`: total prefixes is 3 instead of 1 because overlapping prefixes are now accepted.
