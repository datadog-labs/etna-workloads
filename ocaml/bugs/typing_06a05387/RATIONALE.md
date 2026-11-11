# Rationale
One hunk, ocaml/typing/ctype.ml, `local_non_recursive_abbrev` (the wrapper taking `uenv p ty`):
on `Occur` it now does `raise_unexplained_for Unify` instead of returning `false`.
So `add_gadt_equation` no longer silently skips a cyclic equation but the unification fails.
This reverses fix.diff hunk `@@ -1655,7 +1655,8 @@ let rec local_non_recursive_abbrev ...` (and the `add_gadt_equation`
hunk `@@ -2170,13 +2171,13 @@`, whose `if ... then` is already in today's code but is now dead).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; then final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.
Result: typing-gadts/pr7234.ml fails.
