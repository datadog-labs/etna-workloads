# RATIONALE

Bug: PR#5785, abstract type (functor param `T.two`) vs structural type (`[`One]`) used as GADT index is
treated as incompatible, so the pattern `(One, Two)` is deemed unreachable and the non-exhaustive warning is lost.

Both hunks are in `ocaml/typing/ctype.ml`; today's code no longer has `non_aliased`/`non_aliasable`.

1. `mcomp`: removed the `(Tconstr (p,_,_), _) | (_, Tconstr (p,_,_))` case (the `is_datatype` check), so a
   Tconstr vs non-Tconstr pair falls to the default `raise Incompatible`. Reverses fix hunk
   `@@ -1882,6 +1886,9 @@ let rec mcomp type_pairs subst env t1 t2 =` (which added a Tconstr-vs-other case
   that only raised for non-aliasable types, letting abstract types through).
2. `is_instantiable`: added `&& in_current_module p`, so abstract types from other modules (T.two) are not
   instantiated as GADT equations and go through `mcomp`. This corresponds to the fix's `non_aliasable`
   notion (`in_current_module p`) from hunk `@@ -1844,6 +1844,10 @@ let is_abstract_newtype env p =`.
   This second hunk is an approximation: modern code routes this via is_instantiable.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
tests/typing-gadts/pr5785.ml fails (expected warning missing).

RESULT: injected
