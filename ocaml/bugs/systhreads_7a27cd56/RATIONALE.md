# Rationale
One hunk: ocaml/otherlibs/systhreads/st_pthreads.h, `st_thread_yield`.
Reverses fix.diff hunk `@@ -171,6 +156,44 @@ static INLINE int st_masterlock_waiters(...)` (st_posix.h, now st_pthreads.h),
which added the atomic wake-and-mark-waiter yield. Today's code is again the old
behaviour: release the master lock, nanosleep(1ns), re-acquire. The yielder is not a
waiter while sleeping, so busy yielding threads are unfair. The caller in st_stubs.c
(thread_yield) is unchanged, so no other hunk is needed.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> testyield.ml failed
(bytecode and native: unexpected output). Final `make clean && make -j8 && make -j8 ocamltest`
then run-oracle.sh: testyield.ml fails.
