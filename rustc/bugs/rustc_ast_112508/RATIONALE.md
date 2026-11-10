# Adapted injection for Adjust inner span of implicit self ref argument

Fix: https://github.com/rust-lang/rust/commit/0f7ef1a202b32f783b3e0e05d318208c0c83b8d0

# Rationale
File `compiler/rustc_ast/src/ast.rs`, `Param::from_self`: the `TyKind::ImplicitSelf` type's span is set back to `span` (the whole `&self` / `self` span, `eself.span.to(eself_ident.span)`) instead of `eself_ident.span`.
This reverses the fix hunk `@@ -2353,7 +2353,12 @@ impl Param`, which changed `span: ...` to `span: eself_ident.span` for the infer_ty.
