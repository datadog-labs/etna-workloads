# Adapted injection for Fix ICE-133117

Fix: https://github.com/rust-lang/rust/commit/8a57fa634c46273dab0a283d2ee151735342c514

# Rationale
On 1.99.1 the fix's hunk (`@@ -1940,6 +1940,10 @@ fn merge_trivial_subcandidates`, which hoists
`if candidate.false_edge_start_block.is_none() { ... = candidate.subcandidates[0].false_edge_start_block; }`
above the `if candidate.has_guard { return; }`) is already in its pre-fix position: the assignment sits after the guard early-return.
But 1.99.1 also has a fallback in `remove_never_subcandidates`
(compiler/rustc_mir_build/src/builder/matches/mod.rs) that assigns `false_edge_start_block` when all subcandidates are never-patterns, which masks the bug.
I removed that fallback (the `let false_edge_start_block = ...` and the `if candidate.false_edge_start_block.is_none()` block). The fix commit's message says the parent candidate must get
false_edge_start_block when all subcandidates are never-patterns; that is the behaviour lost, so the guarded case hits `assert!(leaf_candidate.false_edge_start_block.is_some())` (mod.rs:1638).
