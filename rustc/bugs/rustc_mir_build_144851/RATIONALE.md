# Adapted injection for forbid tail calling intrinsics

Fix: https://github.com/rust-lang/rust/commit/c539890ae68b5e0584ffdae2559e3e606da37657

File: compiler/rustc_mir_build/src/check_tail_calls.rs

1. `check_call` (TailCallCkVisitor): removed `if self.tcx.intrinsic(did).is_some() { self.report_calling_intrinsic(expr); }` inside the `if let &ty::FnDef(did, args)` block. Re-expresses fix hunk `@@ -103,6 +103,10 @@` (added that check).
2. Removed `fn report_calling_intrinsic` (emits "tail calling intrinsics is not allowed"). Re-expresses hunk `@@ -280,6 +284,16 @@`. (The comment-move hunk `@@ -89,10 +89,10 @@` is cosmetic.)
