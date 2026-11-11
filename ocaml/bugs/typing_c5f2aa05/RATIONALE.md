# Rationale
1. ocaml/typing/typecore.ml, `type_let` (rec-binding type approximation): reverts
   `@@ -5252,7 +5252,9 @@ and type_let ?check ?check_strict`. Removed `let bound_expr = vb_exp_constraint binding in`
   and call `type_approx env binding.pvb_expr pat.pat_type` again (approximates the raw expression,
   not the constraint/newtype-wrapped one).
2. ocaml/typing/typetexp.ml line 844 (supporting edit, not a fix hunk): dropped the
   `: a maybe_compute_mty` annotation on the `maybe` parameter of `transl_package`
   (already given by the `type a.` signature). Without it the buggy compiler cannot
   compile its own source (`Unbound type constructor a`), so the build would fail.
   Behaviour-neutral.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> build OK;
tests/typing-gadts/test.ml fails (expect output differs).
