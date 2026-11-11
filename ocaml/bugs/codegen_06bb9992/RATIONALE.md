# Rationale
Hunks (asmcomp/cmm_helpers.ml, div_int and mod_int fallback case): removed `bind "dividend" c1` wrapper so the dividend is evaluated inside the branch, after the divisor check (and after the divisor-zero test). Reverses fix.diff hunks `@@ -409,9 +409,10 @@ let rec div_int` and `@@ -445,9 +446,10 @@ let mod_int` (in cmmgen.ml, now cmm_helpers.ml).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle: pr7533.ml fails (native; bytecode passes).
