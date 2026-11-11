# Adapted injection for Check the base of the place too!

Fix: https://github.com/rust-lang/rust/commit/49c4ebcc409b1537fb0cf99134f5166481096c5f

# Rationale
File: compiler/rustc_middle/src/ty/closure.rs, fn `child_prefix_matches_parent_projections` (the by_move_body.rs capture-matching logic moved here via `analyze_coroutine_closure_captures`).
Re-expresses fix hunk `@@ -149,17 +149,25 @@ impl MirPass for ByMoveBody`, which added
`parent_base.var_path.hir_id != child_base.var_path.hir_id ||` to the parent/child match condition
(plus the PlaceBase::Upvar extraction). Reverted: the base (upvar hir id) is no longer compared; only projection kinds are,
so a child capture of a different variable with an empty/overlapping projection prefix matches the wrong parent (`*x`/`*y` case).
The other hunks (import, popping last parent capture/leftover assert) have no equivalent need/are structural.
