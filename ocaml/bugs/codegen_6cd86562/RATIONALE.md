# Rationale
Bug: CSE treats +0.0 and -0.0 as equal because Mach `Iconst_float` holds a float (structural `=`), not bit pattern.
Hunks (reversing fix.diff, amd64 only is built; other arch emitters untouched):
- asmcomp/mach.ml, mach.mli: `Iconst_float of int64` -> `of float` (reverses `@@ -36,7 +36,7 @@ type operation`).
- asmcomp/selectgen.ml: pass `n` instead of `Int64.bits_of_float n` (reverses selectgen hunk).
- asmcomp/printmach.ml: print float directly (reverses printmach hunk).
- asmcomp/amd64/emit.mlp: convert float to bits at emission (`match Int64.bits_of_float f`, `add_float_constant (Int64.bits_of_float f)`), adapting the emit hunks `@@ -470,7 +469,7 @@ let emit_instr`.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr7042.ml native fails; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle: pr7042 failed.
