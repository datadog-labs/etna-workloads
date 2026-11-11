# Rationale
Single file: ocaml/typing/ctype.ml, function `reify`. Reverses both hunks of fix.diff `@@ -1898,7 +1898,9 @@ let reify env t =` (Tvar case) and the Tvariant case hunk (`@@ -1909,7 +1911,9 @@`): removes the check that raises an Escape error when a reified variable's level is below fresh_constr_scope (today's equivalent of newtype_level). Unused `path` renamed `_path` where needed.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh; final make clean build. Result: pr6158.ml, pr6690.ml, pr7222.ml fail.
