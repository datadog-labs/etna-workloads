# Adapted injection for Detect when move of `!Copy` value occurs within `loop` and should likely not be cloned

Fix: https://github.com/rust-lang/rust/commit/14473adf425623268252a4d10b5dd0d4f458daad

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/conflict_errors.rs, fn `suggest_hoisting_call_outside_loop`.
In the `hir::ExprKind::Let(_)` arm (move expr inside a `while let` condition) I removed the
`can_suggest_clone = false;` assignment (replaced by a no-op). This re-expresses the fix hunk
`@@ -747,8 +747,166 @@ ... fn suggest_hoisting_call_outside_loop`, which added
"`can_suggest_clone = false;` // while let Some(_) = foo(non_copy.clone()) { }" so that suggest_cloning is
skipped (#121466). Without it, the semantically wrong `.clone()` suggestion returns for `while let` conditions.
