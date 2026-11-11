# Adapted injection for fix incorrect param env in dead code lint

Fix: https://github.com/rust-lang/rust/commit/b92c2f792c33fbb180358997c5368f336f8912d2

Fix hunk (dead.rs, `@@ -242,7 +242,9 @@` / `@@ -255,15 +255,14 @@`): replaced `param_env(last_did)` / `param_env(field.did)` (wrong env: field/owner def) with the body's param env (`typeck_results().hir_owner`) when normalizing field types.

In 1.99.1 normalization moved to typeck, so the bug was re-expressed in two places:
1. compiler/rustc_hir_typeck/src/expr.rs `check_expr_offset_of` (ADT field case): store the raw `field.ty(tcx, args).skip_norm_wip()` instead of the body-normalized `self.field_ty(...)`, so dead.rs must normalize.
2. compiler/rustc_passes/src/dead.rs `handle_offset_of`: reintroduce `last_did` (initially `expr.hir_id.owner`, updated to `field.did`) and normalize `current_ty` with that def's env (`TypingEnv::non_body_analysis(tcx, last_did)`) rather than the body's env — the removed lines `let mut last_did = ...; last_did = field.did; param_env(last_did)`.
