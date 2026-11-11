# Rationale

fix.diff (#8619) makes failed native allocations undo the young_ptr decrement before entering the GC, so Gc.minor_words stays accurate. In 5.5 the arch emitters no longer do this. The undo happens in the runtime, in `caml_alloc_small_dispatch`, so that is where I reversed it.

## Hunk: ocaml/runtime/minor_gc.c, `caml_alloc_small_dispatch`
Before the change, `young_ptr += whsize` ran at the top, before pending actions, the GC interrupt and the minor collection. Now the undo runs after `caml_do_pending_actions_res()` / `caml_handle_gc_interrupt()`. It runs only if young_ptr is unchanged since entry (tracked with `saved_ptr` and `undone`). A minor GC triggered from those actions therefore sees young_ptr still decremented, so the failed allocation's words are counted in `stat_minor_words`. The allocation is then redone, so the words are counted twice.

This reverses the fix's core change, "If an allocation fails, the decrement of young_ptr should be undone before the GC is entered". The same change appears in several hunks of fix.diff:
- `@@ -600,11 +600,11 @@ let emit_instr fallthrough i` (i386: store young_ptr only after the branch)
- the arm and arm64 hunks
- the amd64 emit.mlp hunks (`caml_call_gc{1,2,3}` and `gc_size`)

These are not applicable to 5.5, because the runtime now does the undo.

## Commands and results
- `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
- Final `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
- Result of the final run: tests/regression/pr7798 fails.
  - The bytecode and `-compact` native configurations print 582 where the reference is 0.
  - The plain native configuration segfaults under the debug runtime (USE_RUNTIME=d). Its minor-GC poisoning loop starts at the decremented young_ptr, which is below young_start.
