# Rationale

Fix: GPR#702 "Avoid checking twice if divisor is zero" (PR#7328). It added `is_safe` to Pdivint/Pmodint/Pdivbint/Pmodbint, and boxed-int divisions went through the zero-divisor check.
The tree is built without flambda, so I could not reproduce the flambda-only symptom. I reintroduced the "boxed-int division zero-check is lost / treated as pure" behaviour in the non-flambda pipeline.

## Hunks
1. `ocaml/middle_end/semantics_of_primitives.ml`: Pdivint/Pmodint/Pdivbint/Pmodbint are again `No_effects, No_coeffects`, regardless of is_safe.
   Reverses fix hunk `@@ -50,9 +50,16 @@ let for_primitive` (and `@@ -77,8 +84,6 @@`, which removed Pdivbint/Pmodbint from the pure list).
2. `ocaml/lambda/translprim.ml`: `%int32_div/mod`, `%int64_div/mod` and `%nativeint_div/mod` now carry `is_safe = Unsafe` instead of `Safe`.
   Reverses the effect of the fix's translcore hunks, e.g. `@@ -255,8 +255,8 @@ let primitives_table`. Before the fix, boxed-int division was not marked as checked, and nothing guaranteed a zero test.
   `Cmm_helpers.div_int` and `mod_int` skip the zero test when `is_safe = Unsafe`. The test `Int32.div n (opaque 0l)` is therefore no longer checked.

## Build and test
`make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: div_by_zero.ml fails natively with SIGFPE (Floating point exception). The bytecode variant passes.
