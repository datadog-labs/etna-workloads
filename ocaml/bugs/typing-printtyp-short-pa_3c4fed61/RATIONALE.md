# Rationale (PR#7543 short-paths printtyp failure on packed module errors)

Hunks (all reverse fix.diff):
1. typing/out_type.ml `apply_subst` – removed the `if tyl = [] then []` guard
   (reverses `@@ -238,10 +238,13 @@ let compose` in typing/printtyp.ml).
2. typing/out_type.ml `tree_of_typexp`, Tconstr case – `if is_nth s && not (tyl'=[])` -> `if is_nth s`
   (reverses `@@ -589,7 +592,7 @@ let rec tree_of_typexp`).
3. typing/typemod.ml `type_package` – today's code had a later arity guard (`decl.type_arity > 0` -> drop
   the constraint) that keeps arity-mismatched Tconstr(path,[]) from reaching Printtyp. Removed it so
   such types are produced again (reverses `@@ -1565,6 +1565,8 @@ let type_package`, the spot where
   the zero-arg Tconstr is built; without this the bug isn't reachable).

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: pr7543.ml fails (toplevel dies with Failure "nth").
