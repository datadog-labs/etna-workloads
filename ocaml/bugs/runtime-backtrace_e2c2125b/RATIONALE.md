# Rationale
Hunk: ocaml/runtime/backtrace_nat.c, `caml_next_frame_descriptor`, in the "return to C" branch: removed `*pc = Saved_return_address(*sp);` after `*sp = First_frame(*sp);`.
This reverses fix.diff hunk `@@ -55,6 +55,7 @@ static frame_descr * caml_next_frame_descriptor(...)`, which added `*pc = **(uintnat**)sp;` so pc is updated when moving to the previous stack chunk. In today's code the equivalent line is the Saved_return_address one. Without it, pc stays stale and the loop re-finds the same descriptor, so the callstack taken from a finalizer misbehaves (here it loops until the timeout).
The testsuite hunk of the fix (callstack.ml) was not touched.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh. Result: tests/backtrace/callstack.ml fails (the native variant times out/killed).
