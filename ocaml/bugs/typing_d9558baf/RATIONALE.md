# Rationale
- ocaml/typing/includecore.ml, `private_variant`, case `Rpresent to1, Reither(...)`: renamed the bound list `ts2` back to `tl2` (in pattern and match scrutinee). It shadows the outer `tl2` accumulator, so `loop (t1::tl1) (t2::tl2)` uses the wrong list. Reverses fix.diff hunk `@@ -759,8 +759,8 @@ let private_variant env row1 params1 row2 params2 =`.
- Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/typing-modules/private.ml failed (Uncaught exception Ctype.Equality_trace).
