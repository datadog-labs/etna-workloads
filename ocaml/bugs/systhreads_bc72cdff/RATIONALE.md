# Rationale
Hunks (fix.diff -> today's code):
1. otherlibs/systhreads/st_pthreads.h, `st_thread_yield`: on Linux it now returns immediately (does nothing), disabling preemption. Reverses hunk `@@ -90,8 +91,14 @@ static void st_thread_join` in st_posix.h (nanosleep-based yield on Linux; the code now lives in st_pthreads.h).
2. otherlibs/systhreads/thread.ml: `let delay = Unix.sleepf` -> `let delay time = ignore(Unix.select [] [] [] time)`. Reverses hunk `@@ -71,7 +71,7 @@ let () =`.
Not reverted: `<time.h>` include, Changes, tests.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: testpreempt.ml fails (output differs from reference).
