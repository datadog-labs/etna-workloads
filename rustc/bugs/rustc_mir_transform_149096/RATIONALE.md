# Adapted injection for Skip unused variables warning for unreachable code

Fix: https://github.com/rust-lang/rust/commit/2c6b1d3430f52ba5ed614e92a38677354f562a68

# Rationale
Fix hunk: `@@ -927,6 +954,10 @@ report_fully_unused` added
`if !self.is_local_in_reachable_code(local) { continue; }` inside `if statements.is_empty()`.
On 1.99.1 that check exists, but the same skip is also done by a later mechanism: `if is_used_after_uninitialized { continue; }` just before it.
Removing only the fix's check left both oracle tests passing, because the later mechanism masked it.

Changes in compiler/rustc_mir_transform/src/liveness.rs, `report_fully_unused`:
1. Removed the `if !self.is_local_in_reachable_code(local) { continue; }` check. This is the fix's hunk 2.
2. Removed the `if is_used_after_uninitialized { continue; }` early-skip, which is the 1.99.1 reimplementation of the same skip for unreachable code.
   Locals in unreachable code (e.g. after `todo!()`) once again get a spurious "unused variable" warning.
The helper `is_local_in_reachable_code` (fix hunk 1) is left as dead code, so it is no longer called.
