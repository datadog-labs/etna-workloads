# RATIONALE
One hunk, ocaml/typing/ctype.ml, `expand_abbrev_gen`: the `Some ty'` branch of the final match (existing expansion found) became `| Some ty' -> assert (not (eq_type ty ty')); ty'`.
Reverses fix.diff hunk `@@ -1384,7 +1384,7 @@ let expand_abbrev_gen kind find_type_expansion env ty =`, which commented out `assert (ty != ty')` (PR#7324). In today's code the equivalent spot is where a memoized expansion is returned; a cyclic `module rec T : sig type t = T.t end = T` hits it, so the type checker dies with an assertion failure instead of reporting "type abbreviation is cyclic".
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/typing-modules/recursive.ml => failed (Uncaught exception: Assertion failed).
