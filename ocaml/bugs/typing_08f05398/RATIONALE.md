# Rationale
One hunk, ocaml/typing/typedecl.ml, in check_recursion: removed
`List.iter (check_regular path args [] []) args;`
Reverses fix.diff hunk `@@ -729,13 +732,15 @@ let check_recursion env loc path decl to_check =`
(the regularity check is no longer applied to the type parameters, so
`type 'a t = 'b constraint 'a = 'b t` is no longer rejected as non-regular).
The other fix hunks (orig_env, check_constraints, variance) were not reverted.

Commands: `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`;
final `make clean && make -j8 && make -j8 ocamltest` built OK.
Result: principality-and-gadts.ml passes; constraints.ml fails (expect run killed, exit -9 / hangs, on the #9866 test).
