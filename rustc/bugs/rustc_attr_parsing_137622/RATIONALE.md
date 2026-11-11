# Adapted injection for fix #137589

Fix: https://github.com/rust-lang/rust/commit/4bf66c57fad749b0efe331c4c9e40f0a65e56e5c

# Rationale
Bug (#137589): when an attribute value is a non-literal expr (e.g. `#[crate_type = foo!()]` with an unresolved macro),
attr parsing used `dcx.has_errors().unwrap()` which ICEs when no error has been emitted yet; the fix used `span_delayed_bug`.

1. compiler/rustc_attr_parsing/src/interface.rs, `AttributeParser::lower_attr_args`: replaced
   `span_delayed_bug(args.span()..., "expr in place where literal is expected ...")` with `self.dcx().has_errors().unwrap()`.
   Re-expresses fix hunk `@@ -333,7 +333,10 @@ impl<'sess> AttributeParser<'sess>` in context.rs
   (`-let guar = self.dcx().has_errors().unwrap();` / `+span_delayed_bug(...)`); code moved to interface.rs.
2. compiler/rustc_attr_parsing/src/parser.rs, `expr_to_lit`: for a non-literal expr under `ShouldEmit::Nothing` (early parsing),
   build an `LitKind::Err(dcx.has_errors().unwrap())` literal instead of returning `Ok(None)`.
   Re-expresses fix hunk `@@ -356,8 +356,11 @@ fn expr_to_lit` (`-let guar = dcx.has_errors().unwrap(); MetaItemLit{... LitKind::Err(guar) ...}`);
   in 1.99.1 the fallback was restructured into `Ok(None)`, so the old unwrap path is restored there.
