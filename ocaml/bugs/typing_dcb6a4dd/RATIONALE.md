# Rationale
File: ocaml/typing/env.ml, `components_of_module_maker'`, `MtyL_functor` case: `fcomp_res` is no longer prefixed
with the prefixing substitution when the functor result is itself a functor (curried functors); it is kept unprefixed.

Reverses the fix.diff hunk `@@ -1291,13 +1288,10 @@ and components_of_module_maker (env, sub, path, mty) =`, where
the fix made `fcomp_res` lazily prefixed (with `fcomp_env`/`fcomp_subst`) instead of eagerly `Subst.modtype sub ty_res`.
Today's code already had the eager shape (the fcomp_env/fcomp_subst fields are gone), so the bug is re-expressed
as a result signature whose prefixing is skipped for curried functors, giving a failing component lookup
(`X2.F(DUMMY)(DUMMY)` in pr51_ok.ml). A broader no-prefix variant broke the bootstrap build, so it was narrowed.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), `sh run-oracle.sh`: pr51_ok.ml failed, pr6651_ok.ml passed.
