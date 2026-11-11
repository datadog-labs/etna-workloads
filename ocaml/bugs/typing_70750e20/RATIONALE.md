# Rationale
File: ocaml/typing/typecore.ml
- Removed `apply_prim` type and `check_apply_prim_type` (reverses fix hunk `@@ -2738,6 +2738,32 @@ let rec is_inferred sexp`).
- In type_expect_ Pexp_apply, dropped the `check_apply_prim_type ... val_type` guards (and `val_type` binding) for %revapply and %apply (reverses `@@ -2943,12 +2969,16 @@ and type_expect_`). The special rule is thus applied even when the external has abstract types.

Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh`
Result: prim-revapply/apply.ml and revapply.ml fail ("This expression has type A.f; This is not a function").
