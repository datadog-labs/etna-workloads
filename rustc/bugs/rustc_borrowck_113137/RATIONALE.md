# Adapted injection for don't suggest `move` for borrows that aren't closures

Fix: https://github.com/rust-lang/rust/commit/5e83ddd27946a74f9ab3390977b99c32a365b7a0

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, fn report_borrowed_value_does_not_live_long_enough.
Removed the guard `if borrow_spans.for_coroutine() || borrow_spans.for_closure()` on the
`(Some(name), BorrowExplanation::UsedLater(_, LaterUseKind::ClosureCapture, ..))` arm.
Re-expresses fix hunk `@@ -1730,18 +1730,19 @@` which added `if borrow_spans.for_generator() || borrow_spans.for_closure()` to that arm.
Without it, non-closure borrows get the "escaping closure, consider move" suggestion.
(The second fix hunk, `|`→`||`, is a no-op style change.)
