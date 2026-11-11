# Rationale
File: ocaml/typing/out_type.ml (printtyp.ml's successor), `Tvariant` case of `tree_of_typexp`.
Reverses fix.diff hunk `@@ -586,17 +588,22 @@ let rec tree_of_typexp sch ty`: re-added `assert (s = Id)`, and stopped
applying the parameter substitution (`apply_subst s tyl`) / handling `is_nth s`, so a row name whose best
short path is an `Nth` substitution (e.g. `[< int u]` with `type 'a u = t`) triggers an assertion failure.
(The other fix hunks are already equivalent/refactored in today's code and left alone.)
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
typing-short-paths/pr6836.ml fails (Assertion failed at out_type.ml).
