# Rationale
Single file: ocaml/runtime/signals.c, `caml_process_pending_signals_res`.
Removed the `sigset_t set` variable, the `pthread_sigmask(SIG_BLOCK, NULL, &set)` query, and the
`sigismember(&set, signo)` skip. Signals are therefore executed even if blocked in the current thread.
Reverses fix.diff hunk `@@ -44,20 +44,57 @@` (void caml_process_pending_signals(void)): the
`caml_sigmask_hook(SIG_BLOCK, NULL, &set)` / `sigismember(&set, i)` -> continue check, i.e. "checking whether a
signal is masked before handling it". Other hunks (hook plumbing) not reverted; today's code calls pthread_sigmask directly.

Commands: `make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: threadsigmask.ml fails (bytecode and native; "Signal received in an unexpected thread !"); signal.ml passes.
(A `make clean` full rebuild hit the tool timeout once; the subsequent build completed and was tested.)
