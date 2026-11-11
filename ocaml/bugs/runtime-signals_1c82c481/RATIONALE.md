# Rationale
One hunk, in `ocaml/runtime/signals.c`, function `caml_process_pending_signals_res`.
It removes the check of the blocked-signal mask (`pthread_sigmask` followed by `sigismember`). Pending signals now run even when they are blocked.
It also removes the now-unused `sigset_t set` variable and adjusts the comment.

This reverses the fix.diff hunk `@@ -41,24 +41,55 @@` of `runtime/signals.c`, which added the `caml_get_sigmask_hook` mask check before executing signals. In today's code the hook is a direct `pthread_sigmask` call.
The other fix hunks were not reverted: the `sigpending` merge, the systhreads hook and the renames.

Commands run:
`cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`

Result: `tests/lib-systhreads/threadsigmask.ml` fails in both bytecode and native, with "Signal received in an unexpected thread !" in the output.
