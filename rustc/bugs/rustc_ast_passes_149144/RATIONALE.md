# Adapted injection for Reject `async fn` in `const impl` during AST validation

Fix: https://github.com/rust-lang/rust/commit/c108451faf1fe034a09c02e8d5b217beafeddea6

# Rationale
File: compiler/rustc_ast_passes/src/ast_validation.rs, `visit_assoc_item` (match on `outer_trait_or_trait_impl`).
Re-expresses fix hunk `@@ -1714,9 +1720,10 @@ impl<'a> Visitor<'a> for AstValidator<'a>`, which changed
`Some(TraitOrImpl::Impl { constness })` to `Some(parent @ TraitOrImpl::Impl { constness })` and added
`self.check_async_fn_in_const_trait_or_impl(sig, parent);`. I removed that call (and the `parent @` binding),
so `async fn` in inherent `const impl` is no longer rejected in AST validation (the original ICE path).
The message/context hunks (messages.ftl, errors.rs, `context` string) only affect wording and are left as is.
