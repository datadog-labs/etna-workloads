# Adapted injection for AST validation: Improve handling of inherent impls nested within functions and anon consts

Fix: https://github.com/rust-lang/rust/commit/7d428db605d305198481b2201f46f5f91d5f8369

# Rationale
File: compiler/rustc_ast_passes/src/ast_validation.rs, `AstValidator::visit_item`, `ItemKind::Impl { of_trait: None }` arm.

Fix hunk `@@ -930,35 +930,38 @@ impl<'a> Visitor<'a> for AstValidator<'a>` wrapped the inherent-impl handling in `self.with_in_trait_impl(None, |this| {...})`, which resets the outer trait/trait-impl context so that an inherent impl nested in a trait's default fn or an anon const is not treated as being inside the trait.
In 1.99.1 that reset is `with_in_trait_or_impl(Some(TraitOrImpl::Impl{..}), ..)` around the assoc items. I removed it (items are walked with the inherited context), so the outer `Trait`/`TraitImpl` context leaks into the nested inherent impl. Its `pub fn` items are then rejected, as before the fix (issue #89342).
