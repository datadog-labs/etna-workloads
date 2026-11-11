# Adapted injection for Provide help on closures capturing self causing borrow checker errors

Fix: https://github.com/rust-lang/rust/commit/c82545955ea526c0bb6878ee12fa9959e8de3b89

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, `report_conflicting_borrow` (the (Mut, Shared) arm).
Removed the call `self.suggest_binding_for_closure_capture_self(&mut err, &issued_spans);`.
Re-expresses fix hunk `@@ -958,7 +962,13 @@ ... (BorrowKind::Mut, BorrowKind::Shared)` which added the call
`self.suggest_binding_for_closure_capture_self(&mut err, issued_borrow.borrowed_place, &issued_spans);`.
Before the fix, no "pass &Self into the closure" suggestion was emitted. Added `#[allow(dead_code)]` on the now-unused helper to keep the build warning-free.
