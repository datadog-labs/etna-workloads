# Rationale
One hunk, ocaml/typing/typemod.ml, in `transl_signature` (Psig_module case):
the check `if not (Env.is_aliasable p env) then raise (Error (..., Cannot_alias p))`
was removed, leaving `| Mty_alias _ -> Mp_absent`. This reverses the fix hunk
`@@ -1499,7 +1500,10 @@ and transl_signature ?(toplevel = false) env sg =`
(today's code uses `is_aliasable` instead of `is_functor_arg`). The `Cannot_alias`
constructor and its report_error case were left in place (now unused by the raise site; harmless).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final
`make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: pr13185.ml and sigsubst.ml fail.
