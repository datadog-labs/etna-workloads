# Rationale
Hunk: ocaml/lambda/simplif.ml line ~301 (simplify_exits, Lstaticraise inlining): `Llet (Strict, kind, y, l, r)` -> `Llet (Alias, ...)`.
Reverses fix.diff hunk `@@ -282,7 +282,7 @@ let simplify_exits lam` in bytecomp/simplif.ml (file now lambda/simplif.ml). Impure args get treated as aliases and may be dropped/duplicated (#8558).
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh` -> localfunction.ml fails (assertion at line 32, `!r = 1`).
