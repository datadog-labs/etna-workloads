# Adapted injection for Only assert for child/parent projection compatibility AFTER checking that theyre coming from the same place

Fix: https://github.com/rust-lang/rust/commit/69b690f0f69c7d7bc783df6295bdc6b14d65f07b

# Rationale
File: compiler/rustc_middle/src/ty/closure.rs (the logic moved here from by_move_body.rs).
- `analyze_coroutine_closure_captures`: removed the post-match assert (projection length check) inside the `while` loop body. Re-expresses fix hunk `@@ -154,6 +154,14 @@ impl<'tcx> MirPass<'tcx> for ByMoveBody` (added `assert!(child_capture.place.projections.len() >= parent_capture.place.projections.len(), ...)` after matching).
- `child_prefix_matches_parent_projections`: re-added `assert!(child.projections.len() >= parent.projections.len())` before the hir_id (same-variable) comparison. Re-expresses fix hunk `@@ -244,7 +252,6 @@ fn child_prefix_matches_parent_projections` (which removed that assert). Now it fires for captures of different upvars.
