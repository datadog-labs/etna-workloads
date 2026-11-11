# Adapted injection for Fix ICE for parsed attributes with longer path not handled by CheckAttrVisitor

Fix: https://github.com/rust-lang/rust/commit/2f05fa6fffb857c08edd0af2dc69f05fa1f02703

# Rationale
compiler/rustc_passes/src/check_attr.rs, `check_attributes` (Unparsed arm): removed the early `return` guarded by
`rest.len() > 0 && AttributeParser::is_parsed_attribute(slice::from_ref(name))` (and changed `[name, rest @ ..]` to `[name, ..]`).
Re-expresses fix hunk `@@ -373,11 +375,18 @@ impl<'tcx> CheckAttrVisitor<'tcx>` which added that check ("Check if we tried to use a builtin attribute as an attribute namespace, like `#[must_use::skip]`"). Without it, `#[must_use::skip]` hits the `span_bug!("builtin attribute ... not handled by CheckAttrVisitor")` ICE.
The `is_parsed_attribute` helper (context.rs hunk) already exists in 1.99.1 and was left alone (now an unused import warning only).
