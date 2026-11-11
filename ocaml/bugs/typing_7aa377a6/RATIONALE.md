# Rationale
One hunk, in `ocaml/typing/env.ml`, function `components_of_functor_appl`:
removed the call `!check_well_formed_module env loc ("the signature of " ^ Path.name p) mty;`
and changed the now-unused `~loc` parameter to `~loc:_` (needed to avoid an unused-variable error).

Reverses the fix.diff hunk `@@ -1899,6 +1901,8 @@ let components_of_functor_appl f env p1 p2 =`
in typing/env.ml, which added the lazy well-formedness check of functor application results
(`check_well_formed_module` forward ref).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then the final
`make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: typing-modules/pr7726.ml fails (the expect process is killed, exit code -9, i.e. runaway recursion/stack overflow).

RESULT: injected
