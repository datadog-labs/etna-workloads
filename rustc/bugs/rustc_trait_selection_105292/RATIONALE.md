# Adapted injection for Clean up

Fix: https://github.com/rust-lang/rust/commit/21c5ffe008cce39bcd676ed197f691adbfbf7a2f

File: compiler/rustc_trait_selection/src/traits/const_evaluatable.rs, fn satisfied_from_param_env (two hunks, reversing both fix hunks).

1. Visitor::visit_const — re-expresses fix hunk `@@ -186,8 +186,9 @@`: fix changed `} else if let ty::ConstKind::Expr(e)` into a separate `if`, so subtrees of a matching const are still visited. Restored the `else if`, so after a match the visitor does not recurse into the Expr's children.
2. Caller loop — re-expresses fix hunk `@@ -208,35 +209,20 @@`: fix replaced the fresh `Visitor{.. single_match: None}` plus merge logic with `single_match` threaded through. Restored the fresh visitor per predicate and the merge match (None/Ok(prev)==inner/else Err).
(The third part of that hunk, commit_if_ok/new_in_snapshot, was already not present in 1.99.1 in either form, so left alone.)
