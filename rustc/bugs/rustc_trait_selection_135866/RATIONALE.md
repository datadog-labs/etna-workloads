# Adapted injection for Don't pick `T: FnPtr` nested goals

Fix: https://github.com/rust-lang/rust/commit/3ef506fb4dc9415620d4f09be022834d02201257

# Rationale
File: compiler/rustc_trait_selection/src/solve/fulfill/derive_errors.rs, `BestObligation::visit_goal` (moved from fulfill.rs in 1.99.1).
Removed the separate loop over `nested_goals` that returned `ControlFlow::Break(self.obligation.clone())` when a `T: FnPtr` nested goal had `Err(NoSolution)`.
Re-expresses fix hunk `@@ -513,8 +513,27 @@ impl<'tcx> ProofTreeVisitor<'tcx> for BestObligation<'tcx>` (the added `for nested_goal in &nested_goals { ... fn_ptr_trait ... return ControlFlow::Break(...) }`). The `nested_goals` variable is kept. The `#[derive(Debug)]` hunk is not reverted (no behavioural effect).
Result: failing `T: FnPtr` nested goals are picked as leaf errors again.
