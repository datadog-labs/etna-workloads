# Adapted injection for Fixes #109436: add parentheses properly

Fix: https://github.com/rust-lang/rust/commit/20f3f437d1f48706930cdb6e9e5089131a34d006

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, closure `try_borrowing` in `suggest_borrow_for_unsized...`-area (borrow suggestion), the `needs_parens_pre` match.
The fix hunk `@@ -1358,6 +1358,34 @@` added a special case: when the expression is the receiver of a method call (`foo.into()`), suggest `(&foo).into()`. In 1.99.1 this became `needs_parens_pre` (MethodCall base => true) with the `(true, false)` arm ("Issue #109436"). I made that arm unreachable by making `needs_parens_pre` false for method receivers, restoring the old behaviour (suggest `&foo.into()`, no parens).
