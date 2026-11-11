# Rationale
Hunk: ocaml/asmcomp/amd64/arch.ml, `division_crashes_on_overflow` changed true -> false.
Reverses fix.diff hunk `diff --git a/asmcomp/amd64/arch.ml ... @@ -51,6 +51,10 @@ let size_addr = 8` (which added `division_crashes_on_overflow = true` for amd64). In today's code the flag is consumed by safe_divmod_bi in asmcomp/cmm_helpers.ml, so the min_int / -1 guard for boxed Int64/Nativeint division is no longer emitted on amd64 (PR#5513).

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: tests/basic/boxedints.ml native fails (SIGFPE, exit -8); bytecode passes.
