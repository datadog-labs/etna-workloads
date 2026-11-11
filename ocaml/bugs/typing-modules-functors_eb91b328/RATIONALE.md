# Rationale
Hunk: ocaml/typing/typemod.ml, in type_module_aux (Pmod_functor case): body typed with
`type_module ~strengthen ~funct_body None newenv sbody` instead of `~strengthen:true`.
Reverses fix.diff hunk `@@ -2105,7 +2105,7 @@ and type_module_aux ~alias sttn funct_body anchor env smod`
(which changed `type_module sttn ...` to `type_module true ...`). Functor bodies inherit the
strengthening flag from the application context, so type equalities are lost.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` (and final make clean rebuild):
pr10298.ml and nondep_private_abbrev.ml fail.
