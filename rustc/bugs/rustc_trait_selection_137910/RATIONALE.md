# Adapted injection for Improve error message for AsyncFn trait failure for RPIT

Fix: https://github.com/rust-lang/rust/commit/e213f4beeabbb2604565a8e9324f66c5c72780c6

# Rationale
1. compiler/rustc_trait_selection/src/traits/select/confirmation.rs, `confirm_async_closure_candidate`: the `AsyncFnKindHelper` nested obligation is again built with `obligation.with(tcx, trait_ref)` instead of `Obligation::new(.., obligation.derived_cause(ObligationCauseCode::BuiltinDerived), ..)`. Re-expresses hunk `@@ -984,8 +984,10 @@` (`nested.push(Obligation::new(... derived_cause(BuiltinDerived) ...`).
2. compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, `note_obligation_cause_code` (coroutine-closure upvar note): removed `is_builtin_async_fn_trait` and the `&& !is_builtin_async_fn_trait` condition. Re-expresses hunk `@@ -3191,7 +3191,10 @@` (`if !is_upvar_tys_infer_tuple && !is_builtin_async_fn_trait`).
The fulfillment_errors.rs hunk (AsyncFn support in the closure-kind error) was not reverted; the two hunks above suffice to reintroduce the confusing/incorrect message.
