# Rationale
Hunk: runtime/backtrace_byt.c, read_main_debug_info: removed the early `CAMLreturn0` guard
(`caml_params->cds_file == NULL && caml_byte_program_mode == EMBEDDED`) that skips reading debug info
for -output-complete-exe programs. Reverses fix.diff hunk `@@ -350,6 +350,14 @@ static void read_main_debug_info(struct debug_info *di)`.
The other fix hunks (enum/variable/bytelink setting) are only supporting definitions and are left in place (today's code names it EMBEDDED).
Result: with OCAMLRUNPARAM=b=1 a complete-exe program tries to read debug info from itself and prints "Cannot print locations: bytecode executable program file has wrong magic number".
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/output-complete-obj/github9344.ml failed; final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh -> same failure.
