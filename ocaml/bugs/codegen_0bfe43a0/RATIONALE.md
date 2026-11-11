# Rationale
Fix hunk reversed: `lambda/simplif.ml` `@@ -762,7 +762,8 @@ let simplify_local_functions lam` (added `Lambda.function_is_curried lf &&` guard
before `enabled lf.attr`). In today's code the guard no longer exists textually; Tupled functions are
excluded because `exact_application` (kind-aware) is used in `simplify_local_functions`.
Change (ocaml/lambda/simplif.ml):
- Added helper `local_exact_application` which calls `Lambda.find_exact_application Curried`, ignoring the function kind.
- Used it in the two places in `simplify_local_functions` (Lapply arity check and rewrite) instead of `exact_application`,
  so Tupled local functions are again turned into static continuations, miscompiling `tupled (0,1) 2`.
(The hunks in lambda.ml/lambda.mli, which add `function_is_curried`, are left; they are only a helper.)

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: tupled.ml and tupled2.ml fail in native mode (bytecode passes).
