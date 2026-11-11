# Rationale

File: ocaml/typing/typemod.ml, function `type_package`.

Fix hunk reversed: `@@ -1518,6 +1518,8 @@ let type_package env m p nl tl =` in typemod.ml.
The fix added a case `Tmod_constraint ({mod_desc=Tmod_ident (mp,_)}, mty, Tmodtype_implicit, _) -> (mp, env)  (* PR#6982 *)`
so that a packed module alias with an implicit constraint is used by its path. Today's code had that case merged into
the `Tmod_ident` branch (`extend_path mp`). I split it out again: `Tmod_ident` keeps the path, while
`Tmod_constraint(Tmod_ident, Tmodtype_implicit)` now goes through a fresh `%M` module
(`Env.enter_module ~scope:(Ctype.create_scope ()) "%M"`), i.e. the pre-fix fallback behaviour. The explanatory comment was dropped too.
Pre-fix, the `%M` path leaks into the package constraint types, giving the PR#6982 spurious type error.
(Merely deleting the special case did not fail today, since the current fallback uses `enter_signature`, so the old `%M` fallback is used for this case.)

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: pr6982_ok.ml fails (ocamlc: "This expression has type (module S with type t = (module A.A_S)) but ... (module S with type t = %M.t)").
