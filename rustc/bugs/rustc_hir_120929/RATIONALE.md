# Adapted injection for Wrap dyn type with parentheses in suggestion

Fix: https://github.com/rust-lang/rust/commit/31e581ec1201aac9a3475b16d2100a3ddd35e2e3

# Rationale
File: compiler/rustc_hir/src/hir.rs, `Generics::bounds_span_for_suggestions`.
Re-expresses the fix hunk `@@ -644,13 +644,49 @@ impl<'hir> Generics<'hir>` which added the `span_for_parentheses` detection
(`Fn() -> dyn Trait` / `&'static dyn Trait` return types, returning `Some(ret_ty.span)`) and the
`Some((span.shrink_to_hi(), Some(span.shrink_to_lo())))` open-paren span.
Buggy (pre-fix) behaviour restored: the function always returns `(bound.span().shrink_to_hi(), None)`, so no
parentheses are ever suggested around `dyn` return types. Callers (already adapted to the tuple return type) are unchanged.
