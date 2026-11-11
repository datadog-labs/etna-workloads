# Rationale
One hunk, runtime/signals.c, in `caml_record_signal`: replaced `caml_interrupt_all_signal_safe();` (and the explanatory comment) with `caml_interrupt_self();`. This reverses fix.diff hunk `@@ -119,8 +115,28 @@ CAMLexport void caml_record_signal(int signal_number)` (signal handler goes back to using the TLS-based interrupt of only the current domain).
Other fix hunks (domain.c interrupt_word atomics, etc.) are left in place; they are unused-but-harmless helpers now.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/parallel/catch_break.ml fails (assertion Caml_state_opt != NULL in caml_interrupt_self). Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: same failure.
