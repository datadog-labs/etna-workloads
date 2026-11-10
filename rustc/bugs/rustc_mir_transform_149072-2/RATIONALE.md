# Adapted injection for Fix the issue of unused assignment from MIR liveness checking

Fix: https://github.com/rust-lang/rust/commit/4930d3e6129b17538e687f97c3b3f3e0dcaea76f

# Rationale
File compiler/rustc_mir_transform/src/liveness.rs, fn report_unused_assignments (AssignmentResult).
Re-expresses fix hunk `@@ -1048,26 +1053,28 @@`: the fix replaced the early
`if maybe_drop_guard(...) { continue; }` with `is_maybe_drop_guard` plus a per-statement
`if !is_direct && is_maybe_drop_guard { continue; }`. I restored the early
`if is_maybe_drop_guard { continue; }` so direct dead assignments to drop-guard-typed
places (e.g. Vec) are no longer reported. (The is_direct plumbing from other hunks already exists.)
