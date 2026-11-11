# Rationale
One file changed: ocaml/otherlibs/unix/sleep_unix.c (today's name for otherlibs/unix/sleep.c).
- Hunk in the HAS_NANOSLEEP branch (fix hunk `@@ -35,26 +35,31 @@ CAMLprim value unix_sleep`): moved caml_enter_blocking_section/caml_leave_blocking_section out of the EINTR retry loop, and removed the MPR#7903 comment. A signal's OCaml handler therefore does not run until the whole sleep ends.
- Same for the HAS_SELECT branch (second half of that fix hunk).

Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh`.
Result: delayintr.ml fails (output "No signal received"/"Received signal late" instead of "Received signal early").
