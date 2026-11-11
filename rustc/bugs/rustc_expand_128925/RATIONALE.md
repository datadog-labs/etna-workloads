# Adapted injection for derive(SmartPointer): register helper attributes

Fix: https://github.com/rust-lang/rust/commit/5534cb0a4a3907db50956f7664ab2e5c3b2bc00a

# Rationale
One hunk: compiler/rustc_expand/src/base.rs, `SyntaxExtension::new` (builtin-macro branch). For a `#[rustc_builtin_macro]` named `CoercePointee`, helper attrs are dropped (empty Vec) instead of using `attributes(pointee)`.
This re-expresses fix hunk `@@ -1060,7 +1060,7 @@` in library/core/src/marker.rs: `-#[rustc_builtin_macro]` / `+#[rustc_builtin_macro(SmartPointer, attributes(pointee))]`, i.e. registering `pointee` as a helper attribute. library/ is not editable, so the equivalent is done compiler-side. (The other hunk, removing the builtin `pointee` attr from builtin_attrs.rs, is already gone in 1.99.1.)
