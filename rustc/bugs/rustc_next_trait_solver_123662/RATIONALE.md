# Adapted injection for Don't rely on upvars being assigned just because coroutine-closure kind is assigned

Fix: https://github.com/rust-lang/rust/commit/6f96d7d012fba4064e40a9698e6cfc6a3d941e0a

Removed the "upvars not yet constrained (is_ty_var)" guards that the fix added (in 1.99.1 the files moved to rustc_next_trait_solver):
- rustc_next_trait_solver/src/solve/assembly/structural_traits.rs (both extract_tupled_inputs_and_output_from_(async_)callable CoroutineClosure arms): dropped `&& !args.tupled_upvars_ty().is_ty_var()` — fix hunks @@ -292 and @@ -401.
- rustc_next_trait_solver/src/solve/normalizes_to.rs consider_builtin_async_fn_kind_helper_candidate: dropped "Bail if the upvars haven't been constrained" ambiguity — fix hunk @@ -487.
- rustc_trait_selection/src/traits/project.rs (confirm_async_closure_candidate): dropped `&& !args.tupled_upvars_ty().is_ty_var()` — hunks @@ -1601/-1731.
- rustc_trait_selection/src/traits/select/candidate_assembly.rs (CoroutineClosure arm): dropped the "Ambiguity if upvars haven't been constrained yet" guard — hunk @@ -400.
