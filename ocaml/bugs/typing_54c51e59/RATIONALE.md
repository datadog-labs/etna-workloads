# Rationale

The fix (a revert of PR#6465) restored an older behaviour. Under that behaviour a module path
used as a module expression is strengthened with plain (non-alias) submodule signatures.
`include M` is the exception, because it explicitly turns submodules into aliases. With the fix
in place, `module P : sig ... module B = M.B end = M` is rejected.
Today's code handles aliasing through the `~aliasable` argument to strengthening, so I
re-expressed the fix in those terms.

## Hunks (both in `ocaml/typing/typemod.ml`)
1. In `type_module_aux`, case `Pmod_ident`, the call changed from
   `Env.find_strengthened_module ~aliasable path env` to
   `Env.find_strengthened_module ~aliasable:false path env`.
   This reverses the effect of the fix's `typing/mtype.ml` hunks, `@@ -59,18 +59,13 @@ and strengthen_sig`
   and `@@ -33,18 +33,18 @@ let rec strengthen`. Those hunks changed `Sig_module` strengthening from
   "alias unless the path is a functor argument" back to `strengthen_decl ... nopos`. It also reverses the
   `includemod.ml` hunk `@@ -379,11 +379,9 @@ and signature_components`, which changed the strengthening of a module component.
   The result is that `module P : ... = M` no longer type-checks.
2. In `Pstr_include`, the signature handed to `extract_sig_open` is now `modl_type`. For a
   `Tmod_ident` whose path is aliasable, `modl_type` is the alias-strengthened module type. This
   corresponds to the fix's `typing/typemod.ml` hunk `@@ -1391,6 +1389,27 @@ and type_structure`, which added
   alias-making for `include` of an identifier that is not a functor argument. The compiler's own
   sources, such as `include Ident` in `backend_var.ml`, need this to build.

I did not make the other parts of the fix (the `add_functor_arg` plumbing and the `pos` argument)
because today's code no longer has them.

## Commands
`cd ocaml && make clean && make -j8 && make -j8 ocamltest` finished with exit code 0.
`sh run-oracle.sh` then reported `aliases.ml => failed`. The expect output now has
`Error: Modules do not match` for `module P : sig ... end = M`.

An earlier attempt that applied only hunk 1 broke the build of `backend_var.ml`.
