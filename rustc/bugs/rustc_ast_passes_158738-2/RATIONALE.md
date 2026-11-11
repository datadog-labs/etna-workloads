# Adapted injection for Recover from GCE const exprs in next solver

Fix: https://github.com/rust-lang/rust/commit/70bfa0afe99169a8e8eb019cf34b7632ff31e4f2

# Rationale

## Context
fix.diff (commit 70bfa0af, first commit of PR #158738) made the next solver recover with
ambiguity on `ConstKind::Expr` instead of ICEing. In the same PR, a follow-up commit
(6e45dd28502 "Reject GCE with the global next solver", which is in 1.99.1) **reverted those
solver hunks** (the `panic!`/`unimplemented!` on `ConstKind::Expr` are back in 1.99.1's
`compiler/rustc_next_trait_solver/src/solve/mod.rs`, so the fix.diff hunks cannot reverse) and
fixed issue #158428 another way: the feature-gate check now uses `emit_fatal`, so compilation
stops before GCE can lower to `ConstKind::Expr` and reach the solver. It also renamed the test to
`next-solver-gce-incompatible-issue-158428.rs` (the oracle), which expects only the
incompatibility error.

So in 1.99.1 the only thing that implements "don't keep compiling GCE code into the next solver
after the incompatibility error" is that `emit_fatal`. Re-injecting the bug means taking that
protection out.

## Hunk 1: compiler/rustc_ast_passes/src/feature_gate.rs, `check_new_solver_banned_features`
Changed `sess.dcx().emit_fatal(diagnostics::IncompatibleFeatures {..})` back to `emit_err` and
dropped the "Abort immediately..." comment. This brings back the parent-of-fix behaviour: the
`-Znext-solver=globally` + `generic_const_exprs` error is emitted, but compilation goes on and
GCE const handling (and possibly the next solver's `ConstKind::Expr` handling) still runs.

It re-expresses the fix's protection, which is the recovery in the fix.diff hunks:
- `@@ -222,13 +222,21 @@ where` (compute_const_evaluatable_goal):
  `+ ty::ConstKind::Expr(_) => { ... should be rejected by feature gating when the next solver is enabled globally. Recover with ambiguity instead of ICEing while compiling after errors. self.evaluate_added_goals_and_make_canonical_response(Certainty::AMBIGUOUS) }`
- `@@ -257,9 +265,14 @@ where` (compute_const_arg_has_type_goal):
  `- ty::ConstKind::Expr(_) => unimplemented!("`feature(generic_const_exprs)` is not supported in the new trait solver"),`
  `+ ty::ConstKind::Expr(_) => { ... return self.evaluate_added_goals_and_make_canonical_response(Certainty::AMBIGUOUS).map_err(Into::into); }`

In 1.99.1 these "compiling after errors" paths are covered by the fatal abort (same PR, final
form: hunk `@@ -746,8 +746,10 @@` of 6e45dd28502, `-emit_err` / `+emit_fatal`). This is a
faithful translation of the fix into today's code, not a new bug.

## Caveat
On this tree, with this oracle input, the effect shows up as extra follow-up diagnostics
("overly complex generic constant") after the incompatibility error, not as the original ICE.
GCE's abstract-const building rejects the `const {}` block before a `ConstKind::Expr` reaches
the solver. Other GCE inputs that lower to `ConstKind::Expr` would hit the solver's
`panic!`/`unimplemented!`, which are still there in 1.99.1.
