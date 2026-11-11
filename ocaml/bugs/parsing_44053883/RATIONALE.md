# Rationale
Reintroduces the dropped-attribute bug: `-(1 [@foo])` is again folded into the constant `-1`.

Hunks (same edit in `ocaml/parsing/parser.mly` and `ocaml/boot/menhir/parser.ml`, the checked-in generated parser):
- `mkuminus`: removed the `arg.pexp_attributes` = `[]` guard and matched on `name, arg.pexp_desc` only.
  This reverses fix.diff hunk `@@ -151,22 +151,30 @@ let neg_string f =` (first half).
- `mkuplus`: same removal of the guard. This reverses the second half of that same hunk.
- I also removed the explanatory comment that the fix added above `mkuminus`. This is part of the same hunk.

The fix's `boot/menhir/parser.ml` hunk is a binary diff. I applied the equivalent source edit to that file by hand.

Commands run:
- `make -j8 && make -j8 ocamltest && sh run-oracle.sh`
- Final `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.

Result: `tests/parsing/prefix_op.ml` fails. The check-ocamlc.byte-output step differs from the reference.

RESULT: injected
