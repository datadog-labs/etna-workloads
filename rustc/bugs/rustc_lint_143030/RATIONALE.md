# Adapted injection for Fix suggestion spans inside macros for the `unused_must_use` lint

Fix: https://github.com/rust-lang/rust/commit/05d3d17248d63314e9c1bef1c6380b53e2f141ea

compiler/rustc_lint/src/unused/must_use.rs, UnusedResults::check_stmt (must_use_op branch): the suggestion span was
`expr.span.find_ancestor_not_from_macro().unwrap_or(expr.span)`; now plain `expr.span`. Re-expresses fix hunk
`@@ -183,6 +183,7 @@` (`let span = expr.span.find_oldest_ancestor_in_same_ctxt();` used for before_span/after_span/NormalExpr),
i.e. suggestions land inside the macro expansion again. (The Def hunk was not changed.)
