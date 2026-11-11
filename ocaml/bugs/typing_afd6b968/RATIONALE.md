# Rationale
File: ocaml/typing/typetexp.ml (TyVarEnv, in the `match unify env v ty with` block).
Removed the `| exception Unify err when is_in_scope name -> raise (Error(loc, env, Type_mismatch err))` case, so impossible constraints are silently dropped (backtracked) again. This reverses the hunk `@@ -313,7 +313,11 @@ end = struct` of typing/typetexp.ml (today's code uses a match-with-exception form).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: typing-misc/constraints.ml fails.
