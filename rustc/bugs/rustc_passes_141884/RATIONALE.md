# Adapted injection for allow macro_use as first segment

Fix: https://github.com/rust-lang/rust/commit/9b94caef4f18e850a43591984c5107692e14a702

# Rationale
Hunk: compiler/rustc_passes/src/check_attr.rs, `CheckAttrVisitor::check_attributes` (Attribute::Unparsed arm, `[name, rest @ ..]`).
Re-expresses fix hunk `@@ -2312,7 +2312,9 @@ fn check_macro_use` (`let name = attr.name().unwrap();` -> `let Some(name) = attr.name() else { return; }`).
That function no longer exists in 1.99.1 (macro_use is parsed by MacroUseParser). The equivalent
"multi-segment path whose first segment is macro_use must not hit single-segment assumptions" early-return is the
`rest.len() > 0 && is_parsed_attribute(name)` guard; adding `*name != sym::macro_use` removes it for macro_use, so
`#[macro_use::a]` hits `span_bug!("builtin attribute ... not handled by CheckAttrVisitor")` (ICE), as the unfixed code crashed (#140255).
