# Adapted injection for use visibility to check unused imports and delete some stmts

Fix: https://github.com/rust-lang/rust/commit/482275b19422b871b986ec0400257a9b80080218

All hunks in compiler/rustc_resolve/src/check_unused.rs (the other fix hunks only removed unused imports and are irrelevant).
- struct UnusedImportCheckVisitor: re-added field `base_use_is_pub: bool` (fix hunk `@@ -59,7 +59,6 @@`, removed `base_use_is_pub`); initialised false in check_unused (hunk `@@ -332,7 +330,6 @@`).
- visit_item: re-added `self.base_use_is_pub = item.vis.kind.is_pub();` in the ItemKind::Use arm (hunk `@@ -146,7 +145,6 @@`).
- check_use_tree: replaced `self.r.effective_visibilities.is_exported(def_id)` with `self.base_use_is_pub` (hunk `@@ -173,7 +171,7 @@`: `-if self.base_use_is_pub {` / `+if ...is_exported(...)`). Syntactic `pub` is used instead of effective visibility.
