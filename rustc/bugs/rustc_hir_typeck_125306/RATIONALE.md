# Adapted injection for Force the inner coroutine of an async closure to `move` if the outer closure is `move` and `FnOnce`

Fix: https://github.com/rust-lang/rust/commit/6b3058204a91bb21e2aa845fedfab85a68f75b94

# Rationale
File: compiler/rustc_hir_typeck/src/upvar.rs, fn `FnCtxt::analyze_closure`.
Removed the case "(2.) The way that the closure uses its upvars means it's `FnOnce`" (`else if self.coroutine_body_consumes_upvars(...) { capture_clause = Value{move_kw} }`).
This re-expresses the fix hunk `@@ -204,6 +204,60 @@ ... analyze_closure`, which added the `else if let (_, ty::ClosureKind::FnOnce, _) = self.process_collected_capture_information(...)` branch forcing the inner coroutine to `move` when the move closure is actually FnOnce. In 1.99.1 that branch is spelled with `coroutine_body_consumes_upvars`. Only case (1) (inferred-kind FnOnce) remains, i.e. the parent behaviour. The helper becomes dead code (warning only).
