# Adapted injection for Add a custom panic message for resuming `gen` blocks after they panicked

Fix: https://github.com/rust-lang/rust/commit/bc926f7c33c5fa12a5d42c1c597245d047346fd6

# Rationale
File: compiler/rustc_middle/src/mir/terminator.rs, `AssertKind::panic_function`.
`ResumedAfterPanic(Gen)` now maps to `LangItem::PanicAsyncFnResumedPanic` instead of `PanicGenFnNonePanic`.
This re-expresses the fix hunk `@@ -250,8 +250,7 @@ impl<O> AssertKind<O>` which replaced
`ResumedAfterPanic(CoroutineKind::Gen(_)) => middle_assert_async_resume_after_panic` (with the FIXME for a custom gen message)
by `middle_assert_gen_resume_after_panic`. In 1.99.1 the gen-specific message is selected via the lang item, so reverting
means gen blocks reuse the async-fn panic message. (The .ftl hunk is not re-expressed; the message file no longer exists in that form.)
