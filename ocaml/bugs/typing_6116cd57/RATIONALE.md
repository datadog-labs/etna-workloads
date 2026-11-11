# Rationale
Bug: #10735, uncaught `Ctype.Unify` from `build_as_type` (typing/typecore.ml).
Hunk 1 (typing/typecore.ml, `build_as_type_extra_inner`): `unify_pat_types p.pat_loc env (instance as_ty) ty1`
-> `unify env (instance as_ty) ty1`. Reverses fix hunk `@@ -542,11 +542,12 @@ let rec build_as_type env p =`
(`unify !env ...` -> `unify_pat_types ...`), which made failure produce a proper typing error instead of a raw Unify exception.
Hunk 2 (same function): removed the `if closed_type_expr ty then instance ty else` shortcut added later by #12313.
It is not in fix.diff; it is needed because today's code short-circuits ground constraints (as in the test) and would never reach the unify call.
The other fix hunks (threading `~refine`) are not reproduced; today's code has been refactored.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr10735.ml failed (Uncaught exception: Ctype.Unify(_)).
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: 1 failed.
