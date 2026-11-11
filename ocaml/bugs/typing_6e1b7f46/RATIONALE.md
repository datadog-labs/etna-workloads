# Rationale
File: ocaml/typing/ctype.ml, `lower_contravariant`, Tconstr case.
Reverses hunk `@@ -890,30 +890,36 @@ let rec lower_contravariant ...` of fix.diff (PR#8701): the fix expands
abbreviations (try_expand) before using the variance of constructor parameters. I removed the
expansion branch (and the `maybe_expand` computation), so parameters are always treated
via declared variance, which causes the principality problem again.
(The Changes/test hunks are not implementation.)

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-poly/poly.ml failed
(expected `'a list t`, got `'_weak4 list t`). Final `make clean && make -j8 && make -j8 ocamltest`
then run-oracle.sh: failed as well.
