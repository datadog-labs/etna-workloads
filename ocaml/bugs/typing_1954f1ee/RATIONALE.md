# Rationale
One hunk, `ocaml/typing/typedecl.ml`, in `ids_slots` inside `transl_type_decl`.

It reverses fix.diff hunk `@@ -1005,24 +1005,26 @@ let transl_type_decl env rec_flag sdecl_list =`. That hunk made the unused-type
callback registration happen only for `Recursive` declarations. Now `Nonrecursive`
declarations also go through the path that calls `Env.find_type ... temp_env` when warning 34 is active.
For nonrec types the new id is not in `temp_env`, so this raises `Not_found`.

Deviation from a plain revert: a plain revert makes the compiler fail to build itself and the stdlib.
They contain `type nonrec` declarations (`utils/diffing.ml`, `stdlib/effect.ml` and others), and they are built with warning 34 on.
So nonrec declarations that are parametric, or that shadow an existing type name, still skip the registration.
The plain `type nonrec unused = used` case from the test takes the buggy path.

Commands run:
- `make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
- Final run: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. The build succeeded.
  `unused_types.ml` fails.
