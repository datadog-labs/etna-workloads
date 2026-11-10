# Adapted injection for Improve code suggestion for incorrect macro_rules! usage

Fix: https://github.com/rust-lang/rust/commit/caf7cdf55895eeacc8b8efca54bdd28c0ebdd3a8

# Rationale
File: compiler/rustc_parse/src/parser/item.rs, fn `report_invalid_macro_expansion_item`.
Re-expresses fix hunk `@@ -2433,17 +2433,32 @@ ... report_invalid_macro_expansion_item`: removed the
`if let Some(path) = path && path.segments.first()...macro_rules && args.delim == Parenthesis` branch that suggests
"to define a macro, remove the parentheses around the macro name"; always emits the old
"change the delimiters to curly braces" + "add a semicolon" suggestions. The `path` param is kept (renamed `_path`),
mirroring the signature hunks of the fix without needing to touch the callers.
