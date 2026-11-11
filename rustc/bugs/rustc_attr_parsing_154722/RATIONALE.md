# Adapted injection for fix(lints): Improve ill_formed_attribute_input with better help message

Fix: https://github.com/rust-lang/rust/commit/65b88ea8ee499345aa8414f16d6cf018c6bdaed6

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/test_attrs.rs, `IgnoreParser::convert`, `ArgParser::List` arm.
Re-expresses the fix hunk `@@ -27,8 +27,15 @@ impl<S: Stage> SingleAttributeParser<S> for IgnoreParser`, which replaced
`ArgParser::List(_) => cx.adcx().warn_ill_formed_attribute_input(..)` with code computing `help` (lint path) and calling
`warn_ill_formed_attribute_input_with_help`. The bug is restored by reverting to the plain call, so the
"if you meant to silence a warning, consider using #![allow(..)]" help is missing.
