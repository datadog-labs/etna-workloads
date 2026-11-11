# Adapted injection for Do not call name() on rpitit assoc_item

Fix: https://github.com/rust-lang/rust/commit/66d47c16873fc04a02cb0bd977ec7f3d50f228f1

# Hunk
suggestions.rs, `suggest_fully_qualified_path`: replaced `if !assoc_item.is_impl_trait_in_trait()` with `if true`, so the "use the fully qualified path" suggestion (which calls `assoc_item.name()`) runs again for RPITIT items.
Re-expresses fix hunk `@@ -2124,16 +2124,19 @@` which added `if !assoc_item.is_impl_trait_in_trait() {` around `err.span_suggestion(... assoc_item.name())`.
