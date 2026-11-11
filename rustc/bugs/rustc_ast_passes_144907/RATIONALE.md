# Adapted injection for fix: Reject async assoc fns of const traits/impls in ast_passes

Fix: https://github.com/rust-lang/rust/commit/2218ff1940bc8baafcc1acf2c861d48499e20d06

Hunk: compiler/rustc_ast_passes/src/ast_validation.rs, visit_assoc_item (both match arms: trait/trait-impl and inherent impl).
Removed the calls `self.check_async_fn_in_const_trait_or_impl(sig, parent);`.
Re-expresses fix hunk `@@ -1566,6 +1581,7 @@ impl<'a> Visitor<'a> for AstValidator<'a>` which added that call. Without it, async fns in const traits/impls are no longer rejected in ast_passes (original bug #117629, later ICE).
