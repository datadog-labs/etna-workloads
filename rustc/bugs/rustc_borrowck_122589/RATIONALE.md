# Adapted injection for Fix diagnostics for async block cloning

Fix: https://github.com/rust-lang/rust/commit/0c7f8b0f89e3b4a8ed46074e39a4de160d098489

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, report_use_of_moved_or_uninitialized.
Removed the `else if let UseSpans::ClosureUse { closure_kind: ClosureKind::Coroutine(CoroutineKind::Desugared(_, CoroutineSource::Block)), .. } = move_spans && can_suggest_clone { self.suggest_cloning(...) }` branch.
This re-expresses fix hunk `@@ -463,6 +464,15 @@` which added exactly that branch (the 1.99.1 form of it). Without it, a value moved inside an async block in a loop gets no clone suggestion.
