# Rationale

**Bug:** `net.Server#listen` errors lacked the libuv description, e.g. `listen EINVAL` / `listen EADDRINUSE` instead of `listen EINVAL: invalid argument` / `listen EADDRINUSE: address already in use`.

**Change (lib/net.js, two call sites in `setupListenHandle`):** `new UVExceptionWithHostPort(...)` -> `new ExceptionWithHostPort(...)` (and the now-unused `UVExceptionWithHostPort` import removed). This corresponds to the fix's hunks in `setupListenHandle` that switched `exceptionWithHostPort` to `uvExceptionWithHostPort`. Today's code uses error classes rather than functions; the old class `ExceptionWithHostPort` is the pre-fix behaviour (no `: description`). `lib/internal/errors.js` is left unchanged (the class stays exported; the reverse hunk of the helper addition isn't needed to restore behaviour).

**Tests:** `parallel/test-net-server-listen-handle` should fail in its `{fd}` case (expects `Error: listen EINVAL: invalid argument`, now gets `Error: listen EINVAL`). Caveat: in this sandbox the test fails earlier (`unable to bind pipe ...: EPERM`, sandbox blocks unix socket bind) both before and after the change, so I could not observe the intended assertion failure. I verified manually: `net.createServer().listen({fd:0x7fff})` prints `Error: listen EINVAL`.
