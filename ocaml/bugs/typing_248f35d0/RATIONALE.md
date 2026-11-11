# Rationale

One hunk, `ocaml/typing/typecore.ml`, in `type_expect_` `Pexp_variant` case: removed
`let ty_expected1 = protect_expansion env ty_expected in` and expand `ty_expected` directly
instead of the protected copy. This reverses the fix.diff hunk
`@@ -3099,9 +3105,10 @@ and type_expect_` (`| Pexp_variant(l, sarg) ->`), which introduced
`ty_expected1 = protect_expansion env ty_expected`.
Effect: with local (GADT) constraints, expanding the expected type can leak equations,
so polymorphic variant expressions in GADT branches give spurious "ambiguous / would escape
the scope of its equation" errors in -principal mode.

Not reversed: the type_cases hunk (the `instance ~partial:true` machinery); restoring it
in today's restructured code broke the stdlib build, so I did not include it.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: typing-gadts/test.ml fails (new Principal-mode ambiguity errors); the other three pass.
