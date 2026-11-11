# Rationale
One hunk, parsing/pprintast.ml, in `module_type`, case `Pmty_functor (s, Some mt1, mt2)` with `s.txt = "_"`:
the argument is printed with `module_type` instead of `module_type1`, so a functor-type argument
is no longer parenthesized (`(S -> S) -> S` prints as `S -> S -> S`).
Reverses fix.diff hunk `@@ -960,22 +960,16 @@ and module_type ctxt f x =` (the `(module_type1 ctxt) mt1` line).
Only this line was undone, since module_type1 doesn't exist as such in the minimal re-expression.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
tests/parsetree/test.ml fails (byte and native output differ from reference); locations_test.ml passes.
