# Rationale
Hunks (both re-introduce the pre-fix behaviour of PR#5619):
1. ocaml/typing/ctype.ml, update_level: the guard `level < get_scope ty1` on the dummy-method Tfield case was removed, so lowering the level of the dummy method always raises (reverses hunk `@@ -733,7 +731,8 @@ let rec update_level`, which added the `(repr ty1).level > level` condition).
2. ocaml/typing/subst.ml, typexp copy: removed the case that keeps a non-generalized dummy-method Tfield uncopied (reverses `@@ -110,6 +110,10 @@ let rec typexp s ty` in typing/subst.ml, which added the "not allowed to lower the level of the dummy method" case).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr5619_bad.ml failed (Uncaught exception Ctype.Unify). Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: failed.
