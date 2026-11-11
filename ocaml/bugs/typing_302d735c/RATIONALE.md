# Rationale

Bug: #9759/#9767 "Spurious GADT ambiguity without -principal". Fix hunk in typing/typecore.ml
`@@ -2918,7 +2907,7 @@ and type_expect_` changed `unify_exp_types loc env ty_record (instance ty_expected)`
to `(instance ty_record) (instance ty_expected)` (record expression, `{g with ...}`).

Hunks changed:
1. typing/typecore.ml, `Pexp_record` case of type_expect_: `(instance ty_record)` -> `ty_record`
   (reverses the hunk above). Test pr9759.ml now reports "This instance of k is ambiguous".
2. typing/typedtree.ml (`alpha_pat`): with the bug restored the compiler can no longer compile
   itself; added a helper `with_pat_desc` (polymorphic annotated) replacing three `{p with pat_desc ...}`
   uses. This is the source-side counterpart to the fix's annotation hunks
   (`@@ -2305,7 +2305,7 @@ let fmt_ebb_of_string` in stdlib/camlinternalFormat.ml, which existed to
   keep sources compiling) — needed only so the tree builds; not a bug itself.
3. middle_end/flambda/augment_specialised_args.ml: `{ var = ...` -> `{ Flambda.var = ...`, same reason
   (warning 18 not-principal becomes an error otherwise).

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: build succeeds; tests/typing-gadts/pr9759.ml => failed (expect diff showing ambiguity error).
