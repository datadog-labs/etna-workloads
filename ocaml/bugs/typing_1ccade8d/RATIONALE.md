# Rationale
typing/includemod.ml, functor_param: in the `None, Some id2` case, removed the fresh `Ident.rename id2` and substitution; now adds id2 directly to env with unchanged subst. Reverses hunk `@@ -496,7 +496,9 @@ and functor_param ~in_eq ~loc env ~mark subst param1 param2` (ident collision in includemod).

Commands: make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh -> pr10693_bad fails (ocamlc exits 0 instead of 2).
