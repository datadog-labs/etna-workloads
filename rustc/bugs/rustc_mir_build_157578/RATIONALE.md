# Adapted injection for Fix diagnostics for non-exhaustive destructuring assignments

Fix: https://github.com/rust-lang/rust/commit/b791fd78694c4b822c40435f2e0ff56fc3fff071

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/check_match.rs, fn `check_let`, `LetSource::PlainLet` branch.
In 1.99.1 the fix was already present (the errors.rs `Inform { descr }` change and signature change exist under diagnostics.rs). I removed the `hir::LocalSource::AssignDesugar` special case, so destructuring assignments are reported again as "local binding" with the `let` bindings note and the `if let` suggestion span.
Re-expresses the fix hunk `@@ -436,7 +436,29 @@ ... fn check_let`: the `if let hir::Node::LetStmt(.. AssignDesugar ..)` branch calling `check_binding_is_irrefutable(pat, "assignment", Some(Inform { descr: "destructuring assignments" }), scrut, None)`.
