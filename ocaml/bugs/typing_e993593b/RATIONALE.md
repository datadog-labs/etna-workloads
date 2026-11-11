# Rationale
File: ocaml/typing/typetexp.ml, function `check_poly_univars` (TyVarEnv).
Change: removed the `promote_associated` step (and its comment) that promoted the row variables
associated with each univar (`v.associated`) to univars; the function now returns just `univars`.
Reverses fix.diff hunk `@@ -206,6 +227,17 @@ end = struct` (the hunk that wraps the univar list in
`let univars = ... in` and folds `promote_associated`). The other hunks only add the plumbing
(`pending_univar`, `row_context`, `associate`), which stays but has no effect on promotion, so
anonymous row variables under `'a. ...` are no longer implicitly universally quantified (bug of #12189).

Commands: `cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: all three oracle tests fail (typing-gadts/test.ml, typing-poly/poly.ml, typing-polyvariants-bugs/pr10664a.ml).
