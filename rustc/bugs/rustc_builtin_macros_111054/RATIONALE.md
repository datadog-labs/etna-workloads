# Adapted injection for Do not recover when parsing stmt in cfg-eval.

Fix: https://github.com/rust-lang/rust/commit/d56ce8e199abec57746286995c7949356e2dfcf2

# Rationale
File compiler/rustc_builtin_macros/src/cfg_eval.rs, CfgEval::parse_and_visit (Annotatable::Stmt arm).
Fix hunk `@@ -166,7 +166,9 @@ impl CfgEval` replaced `parser.parse_stmt(ForceCollect::Yes)?.unwrap()` with `parse_stmt_without_recovery(false, ForceCollect::Yes)`. Reversed: the arm now uses the recovering parser (`parse_stmt_nonterminal`, which emits the error, recovers, and returns None) and `.unwrap()`s it, so a parse failure panics (ICE) in cfg-eval.
The stmt.rs hunk (visibility of parse_stmt_without_recovery) needs no change; it is already pub.
