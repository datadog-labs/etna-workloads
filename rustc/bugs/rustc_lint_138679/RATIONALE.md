# Adapted injection for treat an error taint from const eval lint in late_lint and check_mod_deathness

Fix: https://github.com/rust-lang/rust/commit/8e59e3ba33626a96bf9a1ccfb391fc53cb4b04a6

Two hunks removed, re-expressing the fix's taint checks (the Result/ControlFlow plumbing is left in place, now inert).

1. compiler/rustc_lint/src/builtin.rs, NonShorthandFieldPatterns::check_pat: removed `&& cx.typeck_results().tainted_by_errors.is_none()`.
   Re-expresses fix hunk `@@ -152,7 +152,10 @@ declare_lint_pass!(NonShorthandFieldPatterns ...` (added "The result shouldn't be tainted" guard). Without it check_pat ICEs on tainted typeck results.

2. compiler/rustc_passes/src/dead.rs, MarkSymbolVisitor::visit_nested_body: removed the `if let Some(guar) = typeck_results.tainted_by_errors { return ControlFlow::Break(guar); }` early return.
   Re-expresses fix hunk `@@ -514,15 +523,25 @@ ... fn visit_nested_body` (added the tainted check returning ControlFlow::Break).
