# Adapted injection for Properly handle `async` blocks and `fn`s in `if` exprs without `else`

Fix: https://github.com/rust-lang/rust/commit/37d2ea2fa064411de78ec24a178a05dc02517673

# Hunk: compiler/rustc_hir_typeck/src/coercion.rs, `CoerceMany::report_return_mismatched_types`
(the `due_to_block` branch calling `suggest_missing_break_or_return_expr`)

Fix hunk re-expressed: `@@ -1845,13 +1848,31 @@ ... CoerceMany` — the fix added a loop over
`parent_iter(id)` so that "When suggesting return, we need to account for closures and async blocks,
not just items" (`parent_item = node` for Closure), instead of always using
`let parent_item = hir_node_by_def_id(parent_id.def_id)` and `fn_id = parent_id`.
In 1.99.1 this is `fcx.body_def_id` (the async block / closure body). I reverted to the old behaviour:
the fn decl and `fn_id` come from the enclosing *item* (`hir_get_parent_item(block_or_return_id)`),
ignoring the async block, so for `fn bar() -> Pin<Box<dyn Future..>> { Box::pin(async move { if true { Ok(S) } Err(()) }) }`
the `return` suggestion is no longer produced (return type mismatch against the outer fn).
