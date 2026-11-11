# Rationale
Hunk: ocaml/lambda/translmod.ml, `field_of_str`: removed the `Tcoerce_alias (env, path, cc)` case
(transl_module_path + apply_coercion Alias). Reverses fix.diff hunk `@@ -892,6 +892,9 @@ let field_of_str loc str =`
(file bytecomp/translmod.ml then, lambda/translmod.ml now). Alias coercions now fall into the generic
case and index `ids.(-1)`, giving a fatal error for module aliases in native compile (pr7920).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, and final `make clean` rebuild;
pr7920.ml fails (native: compile fails).
