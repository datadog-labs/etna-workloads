# Rationale
The original bug (#10633): after a Stack_overflow raised from the signal handler, the minor heap pointer
(young_ptr) was not restored. The code in runtime/signals_nat.c (segv_handler, `@@ -224,9 +224,11 @@`) and
signals_osdep.h no longer exists in OCaml 5; stack overflow is now raised from `caml_call_realloc_stack`.

## Hunk: ocaml/runtime/amd64.S, caml_call_realloc_stack failure path
Removed `RESTORE_ALL_REGS` before raising Stack_overflow. RESTORE_ALL_REGS reloads %r15 (young pointer) from
Caml_state->young_ptr; without it %r15 holds a gc_regs bucket address, so the minor heap pointer is wrong after
the exception. Reverses the signals_nat.c hunk `@@ -224,9 +224,11 @@` (young_ptr not restored on Stack_overflow).
The other fix hunks (ARM/ARM64 register macros, Changes, tests) are not applicable/not reverted.

## Commands
`make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> runtime-errors/stackoverflow.ml failed (assertion in domain.c, young_ptr).
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: stackoverflow test fails.
