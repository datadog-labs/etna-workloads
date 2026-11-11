# Rationale
Changed ocaml/typing/typemod.ml, `type_module_aux`, case `Pmod_functor`: the functor argument
type is translated with `transl_modtype` instead of `transl_modtype_functor_arg`, so local aliases
are no longer removed from functor argument types for functor expressions.
Reverses fix.diff hunk `@@ -1560,8 +1564,8 @@ and type_module_aux ...` (`let mty = may_map (transl_modtype_functor_arg env smty)` -> `transl_modtype`).
Other fix hunks (Changes, tests, mtype refactor) not touched.

Commands: `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`, then final
`make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: tests/typing-modules/pr7818.ml fails (expect output differs).
