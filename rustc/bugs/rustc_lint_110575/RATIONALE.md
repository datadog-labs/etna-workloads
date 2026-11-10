# Adapted injection for reimpl `make non_upper_case_globals lint not report trait impls`

Fix: https://github.com/rust-lang/rust/commit/8cad917e689f19f7ea2f9a6d2e5a95c7ee6c77d4

# Rationale
File: compiler/rustc_lint/src/nonstandard_style.rs

1. `NonUpperCaseGlobals::check_item`: re-added the `hir::ItemKind::Impl(hir::Impl { of_trait: None, items, .. })` arm that iterates impl items and lints inherent associated consts (reverses fix hunk `@@ -494,15 +500,6 @@ impl<'tcx> LateLintPass<'tcx> for NonUpperCaseGlobals`, which removed that arm). The lint is emitted at the impl's level, so `#[allow]` on the const is ignored (issue 110573).
2. `NonUpperCaseGlobals::check_impl_item`: removed (reverses hunk `@@ -513,6 +510,12 @@` which added check_impl_item with `!assoc_item_in_trait_impl`; 1.99.1's version used `ImplItemImplKind::Inherent`).
Hunks 1 (helper fn) and 2 (FIXME comment) are not behavioural and unneeded.
