# Adapted injection for Fix ICE of trying to get span from all attrs

Fix: https://github.com/rust-lang/rust/commit/45b4e3c52bd48434b7d140ea109228c9610c5072

In 1.99.1 the helper lives in compiler/rustc_attr_ir/src/attr.rs (not rustc_hir/src/hir.rs).
- rustc_attr_ir/src/attr.rs: removed `Attribute::is_prefix_attr_for_suggestions` (fix hunk `@@ -1304,6 +1304,15 @@ impl Attribute`, which added it).
- rustc_hir_typeck/src/expr.rs `FnCtxt::precedence`: restored the loop `for attr in hir_attrs(id) { if attr.span().desugaring_kind().is_none() { return true; } } false` (fix hunk `@@ -57,25 +57,7 @@`). `attr.span()` ICEs on parsed attrs.
- rustc_lint/src/context.rs `LateContext::precedence`: same restoration (fix hunk `@@ -845,12 +845,7 @@`).
