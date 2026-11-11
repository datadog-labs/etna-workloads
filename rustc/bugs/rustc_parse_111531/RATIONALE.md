# Adapted injection for Fix ice caused by shorthand fields in NoFieldsForFnCall

Fix: https://github.com/rust-lang/rust/commit/ce6cfc37d033eb1fb1f2e3af1c17c218917b54ec

# Rationale
File: compiler/rustc_parse/src/parser/expr.rs, in the parser's recovery for `fn_call(..)` that looks like a struct literal (NoFieldsForFnCall / ParenthesesWithStructFields).
Removed the `// filter shorthand fields` statement (`let fields: Vec<_> = fields.into_iter().filter(|field| !field.is_shorthand).collect();`).
This re-expresses fix hunk `@@ -1180,6 +1180,13 @@ impl<'a> Parser<'a>`, which added that filter. Without it, shorthand fields (e.g. `mx`) are included in `fields`, and `field.span.until(field.expr.span)` is computed for them, which gives the wrong suggestion (the ICE in the original issue).
