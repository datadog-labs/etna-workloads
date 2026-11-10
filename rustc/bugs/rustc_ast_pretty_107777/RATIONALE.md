# Adapted injection for Expand const-if-const trait bounds correctly

Fix: https://github.com/rust-lang/rust/commit/56bf28d4f4236f19f962868f181b15b174d041c4

# Rationale
compiler/rustc_ast_pretty/src/pprust/state.rs, `print_poly_trait_ref`: the pretty printer no longer prints `~const` for `BoundConstness::Maybe` (only `Always` prints `const`). This re-expresses the fix hunk `@@ -1567,8 +1567,18 @@ impl<'a> State<'a>` which added `TraitBoundModifier::MaybeConst => self.word_space("~const")` (and MaybeConstMaybe); before the fix the `~const` modifier was dropped when printing.
