# Rationale
One hunk, ocaml/parsing/pprintast.ml, in `pattern_or`: the or-pattern alternatives are printed with `pattern ctxt` instead of `pattern1 ctxt`, so `(`A as x) | (`B as x)` loses its parentheses under -dsource.
Reverses fix.diff hunk `@@ -397,22 +397,26 @@ and core_type1 ctxt f x =` (which introduced `pattern_or` using `pattern1` for the alternatives).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/parsetree/test.ml failed (source.ml roundtrip mismatch). The incremental build was used (no stdlib/runtime change); a make clean rebuild was not repeated.
