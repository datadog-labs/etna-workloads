# Rationale
File: ocaml/asmcomp/cmm_helpers.ml (div_int and mod_int, generic `(c1, c2)` case).
Removed the `bind "dividend" c1 (fun c1 -> ...)` wrapper around the Cifthenelse, so the dividend is evaluated only inside the non-zero branch (side effects skipped when divisor is 0). Reverses the hunks `@@ -409,9 +409,10 @@ let rec div_int` and `@@ -445,9 +446,10 @@ let mod_int` of asmcomp/cmmgen.ml in fix.diff (code now lives in cmm_helpers.ml).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; then final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh: tests/basic/pr7533.ml fails (native).
