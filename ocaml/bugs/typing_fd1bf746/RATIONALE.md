# Rationale
Two hunks in ocaml/typing/typecore.ml, both reversing hunks of fix.diff's typecore.ml change:
1. `solve_Ppat_alias`: removed the `with_level ~level:(generic_level - 10)` wrapper. Reverses `@@ -911,8 +906,16 @@ and build_as_type_aux`.
2. `build_as_type_aux`, Tpat_construct: re-added instantiating the constructor at `generic_level` and unifying `ty_res` with a fresh var (`newvar`). Reverses `@@ -855,12 +855,7 @@ and build_as_type_aux`.
(The first hunk alone breaks the compiler's own flambda build, so both are needed for a buildable bug.)
The `instance_unshared` hunk (`@@ -829,17 +829,17 @@`) is already present in an equivalent refactored form and was left alone.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh.
Result: build succeeds; existential_as_pattern.ml fails.
