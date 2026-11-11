Bug: recursive-type checks used the non-`_opt` expansion (PR#5026), causing a stack overflow on pr5026_bad.ml.

Hunks:
1. ocaml/typing/typedecl.ml, check_well_founded (line ~886): `Ctype.try_expand_once_opt env ty` -> `Ctype.try_expand_once env ty`.
   Reverses the fix hunk `@@ -1251,7 +1251,7 @@ let rec non_recursive_abbrev` (try_expand_once -> try_expand_once_opt); the recursion check now lives in typedecl.
2. ocaml/typing/ctype.mli: export `try_expand_once` so hunk 1 compiles (support only).

The second fix hunk (cyclic_abbrev `expand_abbrev_opt`) has no counterpart in today's code.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh; final make clean + rebuild. Result: pr5026_bad.ml fails (Fatal error: Stack overflow).
