# Rationale
Single hunk, typing/typecore.ml `check_univars`: reverses the fix.diff hunk
`@@ -2262,15 +2262,28 @@ let list_labels env ty =` (typecore.ml). The fix replaced the
"polyfy exp.exp_type, then unify with ty_expected" logic by instantiating the
expected Tpoly and unifying the expression type against it before polyfy.
I restored the old logic: polyfy exp.exp_type directly, raise Less_general if incomplete,
then `unify env ty ty_expected` (Expr_type_clash on failure), expressed with today's
Errortrace API.
The ctype.ml hunks of the fix (copy_sep) were not reversed (the first was a no-op match refactor;
the second, tried alone, made no oracle test fail, so I reverted it).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`; then final
`make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: test.ml (typing-gadts), poly.ml, pr9603.ml all fail.
