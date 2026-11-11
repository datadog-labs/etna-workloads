# Rationale
Hunk: ocaml/runtime/sync_posix.h, `sync_mutex_create`: removed the
`pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK)` call and its error check, so mutexes are default-type again.
Reverses fix.diff hunk `@@ -197,12 +197,26 @@ typedef pthread_mutex_t * st_mutex;` (otherlibs/systhreads/st_posix.h, now moved to runtime/sync_posix.h), which added the ERRORCHECK attribute.
Effect: recursive lock deadlocks instead of raising Sys_error; unlock errors not reliably reported.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`:
mutex_errors.ml hangs (self-deadlock in the "Self deadlock" section) and hit the 10 min timeout, i.e. does not pass.
(An incremental build without clean did not pick up the header change and still passed.)
