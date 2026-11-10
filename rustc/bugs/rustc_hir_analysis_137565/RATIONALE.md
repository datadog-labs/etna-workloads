# Adapted injection for Fix associated type errors too

Fix: https://github.com/rust-lang/rust/commit/06072468fe8de249a39d2fcc42cea51db2649a80

# Rationale
Fix hunks (`@@ -84,6 +84,8 @@ AssocItemNotFound` in errors.rs and `@@ -151,6 +151,9 @@` in hir_ty_lowering/errors.rs) added `within_macro_span: assoc_name.span.within_macro(span)` and a `#[label(hir_analysis_within_macro)]` field.
In 1.99.1 these are:
- compiler/rustc_hir_analysis/src/diagnostics.rs, struct `AssocItemNotFound`: removed the `#[label("due to this macro variable")] within_macro_span` field (re-expresses the errors.rs hunk).
- compiler/rustc_hir_analysis/src/hir_ty_lowering/errors.rs, `report_unresolved_assoc_item`: removed the `within_macro_span: assoc_ident.span.within_macro(...)` initializer (re-expresses the hir_ty_lowering/errors.rs hunk).
The messages.ftl hunk no longer applies since the label is inline text now.
