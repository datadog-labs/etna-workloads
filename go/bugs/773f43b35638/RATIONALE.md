# Rationale

Fix (#49722): `identical` for `*Signature` substituted x's type parameters for y's before comparing
constraints, params and results, so generic signatures are identical modulo type parameter renaming.

Changed: `src/cmd/compile/internal/types2/predicates.go`, `case *Signature` in `(*comparer).identical`.
The substitution (makeSubstMap and check.subst of bounds, params, results) is removed. Bounds are compared
pairwise as-is, and params/results are compared against y's unsubstituted tuples. This is the pre-fix
behaviour (old identicalTParams plus direct comparison). The type-parameter count check is kept, as in
the old identicalTParams. go/types is not in scope (outside src/cmd/compile).

Oracle: types2 `TestIdentical` fails, e.g. `func X[P ~int](P){}; func Y[Q ~int](Q) {}` is reported
non-identical (P vs Q), and likewise for the `~*P1`/`~*Q1` bound cases.
