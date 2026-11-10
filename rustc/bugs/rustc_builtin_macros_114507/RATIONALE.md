# Adapted injection for Add suggestion to quote inlined format argument as string literal

Fix: https://github.com/rust-lang/rust/commit/d003fd985976ce65d446243df182c935e5395334

# Rationale
File compiler/rustc_builtin_macros/src/format.rs, fn make_format_args (the `Err(err)` arm after expr_to_spanned_string).
Changed the condition `path.segments.len() == 1` to `== 0` in the `if let ExprKind::Block(block, None) ... ExprKind::Path(None, path)` chain.
This re-expresses fix hunk `@@ -171,17 +171,33 @@` which added the branch "quote your inlined format argument to use as string literal" for `{ident}`. Without it (parent behaviour) `eprintln!({stderr})` falls to the "you might be missing a string literal to format with" suggestion.
