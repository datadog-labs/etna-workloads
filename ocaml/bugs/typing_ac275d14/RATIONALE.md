# Rationale

One hunk, in `ocaml/typing/out_type.ml` (today's home of the printtyp code).

The fix's hunk `@@ -642,8 +642,15 @@ let rec tree_of_type_decl id decl` in `typing/printtyp.ml` changed
`tree_of_constructor`. For GADT constructors (those with a return type) it saved `!names`, reset it
to `[]`, printed the return type and the arguments, then restored `names`. That way type variable
names chosen for the type parameters are forgotten inside a GADT constructor.

Today's equivalent is `tree_of_constructor_in_decl`, which wraps `tree_of_single_constructor` in
`Variable_names.with_local_names` when `cd_res` is `Some _`. I changed that branch to call
`tree_of_single_constructor cd` directly, so the names are no longer reset.
Existential variables are therefore printed with names that clash with the type parameters, for example
`'a` where `'a0` is expected.

Commands run:
`make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: omega07.ml, pr5332.ml and test.ml all fail, with expect-output diffs such as
`'a var = O : ('a * unit) var` instead of `('a0 * unit) var`.

RESULT: injected
