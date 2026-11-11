# Adapted injection for Detect allocator for box in must_not_suspend lint

Fix: https://github.com/rust-lang/rust/commit/0db06bf0046b70dee03de07fd6b455173a90c117

# Rationale
File: compiler/rustc_mir_transform/src/coroutine/layout.rs, fn check_must_not_suspend_ty (moved from coroutine.rs in 1.99.1).
Re-expresses the fix hunk `@@ -1964,15 +1964,21 @@ fn check_must_not_suspend_ty`: the Box arm again checks only the boxed type (`args.type_at(0)`), and the `|| check_must_not_suspend_ty(... allocator_ty ... "allocator ")` branch is removed. Allocators marked #[must_not_suspend] are no longer linted.
