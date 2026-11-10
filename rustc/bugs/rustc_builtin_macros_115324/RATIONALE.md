# Adapted injection for Only give autofix suggestion when no named args are present

Fix: https://github.com/rust-lang/rust/commit/c8ee7db6ea272b42e90602007807be6c2191f96b

# Rationale
File compiler/rustc_builtin_macros/src/format.rs, fn report_redundant_format_arguments.
Fix hunk `@@ -767,11 +767,17 @@ fn report_redundant_format_arguments`: added
`let sugg = if args.named_args().len() == 0 { Some(..) } else { None };`.
Reintroduced the bug: suggestion is now always `Some(FormatRedundantArgsSugg{..})`, so the autofix
suggestion is emitted even with named args present. (In 1.99.1 the field is already Option, so errors.rs needs no change.)
