# Adapted injection for Fix suggestion for boxing an async closure body, and also add a suggestion for boxing empty blocks.

Fix: https://github.com/rust-lang/rust/commit/35985091cc0bf18d40f9fdf9bcb81e3dd74f253b

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, in check_block_with_expected (the `coerce.coerce_forced_unit` error closure).
Removed the block `if blk.stmts.is_empty() && blk.expr.is_none() { self.suggest_boxing_when_appropriate(err, blk.span, blk.hir_id, expected_ty, unit) }`.
Re-expresses fix hunk `@@ -1591,6 +1590,15 @@` in checks.rs, which added exactly this call so that empty blocks get the "store this in the heap by calling `Box::new`" suggestion (`Box::new(())`). Before the fix, no such suggestion was emitted for empty blocks.
The other fix hunks (async-closure suggestion, SuggestBoxing enum) were already refactored in 1.99.1 and are untouched.
