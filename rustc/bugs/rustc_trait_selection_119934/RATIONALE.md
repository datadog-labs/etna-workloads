# Adapted injection for Make InferCtxtExt::could_impl_trait less messed up

Fix: https://github.com/rust-lang/rust/commit/04a6fd241bc18391b3f1f6ece1b109acd19842f1

# Rationale
Only hunk changed: `compiler/rustc_trait_selection/src/infer.rs`, `InferCtxtExt::type_implements_trait_shallow` (called `could_impl_trait` before the fix).

Re-expresses fix hunk `@@ -86,64 +99,26 @@ impl<'tcx> InferCtxtExt<'tcx> for InferCtxt<'tcx>`. The fix replaced the old "find any impl whose self type is the same ADT, register that impl's predicates instantiated with the *type's* args, then truncate the last error" logic with a precise selection (`selcx.select(...)`). I restored the old logic, adapted to 1.99.1 APIs (`ObligationCtxt`, `clauses_of`, `TraitErrors`).

The bug: an impl matching only by ADT def id (ignoring its other generic args) is accepted. This gives a wrong `Some(..)` answer and a bad clone suggestion when no real impl applies (issue 119915).

The call-site hunks of the fix (the rename in borrowck/typeck) are not needed. The mutability_errors.rs hunk removed a help message and was not re-injected.
