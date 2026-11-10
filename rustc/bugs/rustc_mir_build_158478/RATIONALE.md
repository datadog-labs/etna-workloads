# Adapted injection for use correct typing mode in mir building for the next solver

Fix: https://github.com/rust-lang/rust/commit/180e599d56c325513f1bcba038952b3cda17575c

In 1.99.1 the fix was already present (helper `TypingEnv::post_typeck_until_borrowck_for_mir_build` in rustc_middle/src/ty/mod.rs still exists, unchanged; it is now unused). I reverted every call site to the pre-fix behaviour:
- rustc_mir_build/src/builder/mod.rs `construct_fn` and `construct_const`: restored `tcx.infer_ctxt().build(TypingMode::non_body_analysis())`, removing the `use_typing_mode_post_typeck_until_borrowck()` / `TypingMode::borrowck` selection (fix hunks `@@ -505,9 +505,15 @@ fn construct_fn` and `@@ -586,9 +592,15 @@ fn construct_const`).
- builder/scope.rs (`@@ -969,8 +969,10 @@`): typing_env back to `TypingEnv::non_body_analysis(self.tcx, self.def_id)`.
- check_tail_calls.rs, check_unsafety.rs, thir/cx/mod.rs, thir/pattern/check_match.rs: typing_env back to `ty::TypingEnv::non_body_analysis(tcx, def)` (the respective `post_typeck_until_borrowck_for_mir_build` hunks).
The ty/mod.rs hunk (adding the helper) was not reversed; leaving the helper unused is harmless.
