# Adapted injection for Don't suggest break through nested items

Fix: https://github.com/rust-lang/rust/commit/0a51ab93cf8a8c11f28cca7a5912a5af23e98a89

# Rationale
compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, `suggest_missing_break_or_return_expr`: removed the
`.take_while(|(_, node)| node.body_id().is_none())` from the parent walk that finds `innermost_loop`.
Re-expresses fix hunk `@@ -874,7 +874,15 @@` (added take_while "look at parents until we find the first body owner"); in 1.99.1 the logic moved here. Without it, the "break with value" suggestion crosses closures/async/fn/const bodies.
