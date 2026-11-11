# Adapted injection for Fix unconditional recursion lint wrt tail calls

Fix: https://github.com/rust-lang/rust/commit/5f4caae11c7a640350fbe90ddc465d8e2fa0156e

# Rationale
File: compiler/rustc_mir_transform/src/check_call_recursion.rs (the lint moved here from rustc_mir_build/src/lints.rs), `TerminatorKind` classification in `TriColorVisitor::visit_terminator`.
Re-expresses fix hunks `@@ -196,8 +196,6 @@` / `@@ -219,12 +217,28 @@`: the fix removed `| TerminatorKind::TailCall { .. }` from the `Break(NonRecursive)` arm and added a `TailCall => Continue(())` arm. I reverted: TailCall is back in the Break(NonRecursive) group and the Continue arm is removed. (The fix's FIXME comment in node_settled was kept; comments only.)
Effect: `become f(!x)` is treated as a function exit, so `f` is no longer linted as unconditionally recursive.
