# Rationale
Fix: typing/typecore.ml hunk `@@ -3338,6 +3338,25 @@ and type_expect_` added a check that an n-ary function type has at least n arrows (so GADT equations from params can't hide arrows). In today's code this is `enforce_syntactic_arity`, called from `Pexp_function` when `contains_gadt = Contains_gadt`.

Hunks (ocaml/typing/typecore.ml):
1. In `Pexp_function`, replaced the `match contains_gadt with ... enforce_syntactic_arity ...` by `ignore contains_gadt;` — removes the arity check (reverses the added unify of ty_function with exp_type).
2. Renamed `enforce_syntactic_arity` to `_enforce_syntactic_arity` only to avoid the unused-value warning-as-error.

Test hunks of fix.diff (testsuite) were not touched.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh: tests/typing-gadts/syntactic-arity.ml fails (expect output differs: the unsound definitions are now accepted); syntactic_arity.ml passes.
