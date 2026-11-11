# Rationale
Fix #9721 replaced the placeholder variance `Variance.full` with `Variance.unknown` (via `unknown_signature`) for approximated type declarations. Today's code already has `unknown_signature ~injective`; the recursive-module approximation used `injective` only when the kind was not abstract. I reverted that site to `full`, so approximated types are assumed injective/invariant.

Hunks:
- `ocaml/typing/typedecl.ml`, `abstract_type_decl`: `type_variance = Variance.unknown_signature ~injective ~arity` became `Misc.replicate_list Variance.full arity`. This reverses the fix hunk `@@ -1541,7 +1541,7 @@ let abstract_type_decl arity =`. The now-unused `~injective` parameter was removed, and so was its computation in `approx_type_decl`.
- `ocaml/typing/typedecl.mli`: dropped `injective:bool ->` from the `abstract_type_decl` signature. This follows from the hunk above.

Tests: the `module rec R/S` case in injectivity.ml is wrongly accepted. The later coerce then segfaults the expect tool (exit -11), so `typing-misc/injectivity.ml` fails.

Commands run: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`. Final: `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh. Result: injectivity.ml => failed.
