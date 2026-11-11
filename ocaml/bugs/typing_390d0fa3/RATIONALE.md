# Rationale
File: ocaml/typing/ctype.ml, function `reify`.
Fix hunk `@@ -1898,7 +1898,9 @@ let reify env t =` (Tvar case) added a check raising Unify/Escape when the variable's level is below the newtype/equation scope level. I removed the equivalent check (`if level < fresh_constr_scope then raise_for Unify (Escape ...)`).
Fix hunk `@@ -1909,7 +1911,9 @@` (Tvariant row_more case): same check removed.
Effect: existential types can escape silently (PR#7222).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: pr6158.ml, pr6690.ml, pr7222.ml all fail.
