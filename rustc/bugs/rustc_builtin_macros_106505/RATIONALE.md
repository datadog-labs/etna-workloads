# Adapted injection for Properly allow macro expanded `format_args` invocations to uses captures

Fix: https://github.com/rust-lang/rust/commit/729185338f1726f60ea2dc282fe6bbf0eb84cb17

# Re-injected bug
File: compiler/rustc_builtin_macros/src/format.rs, `make_format_args`.
Fix hunk `@@ -304,7 +313,7 @@`: `let expr = if is_literal {` -> `if is_direct_literal {`.
I reverted this: the implicit-capture check (`let expr = if is_source_literal { ecx.expr_ident(..) } else { ...error }`) again uses the "source literal" flag instead of the "direct literal" flag, so macro-expanded literals (e.g. indoc-style respanned strings) can't use implicit captures.
Hunk `@@ -147,17 +154,19 @@` destructuring: `is_direct_literal` is bound as `_` to avoid an unused-variable warning (the field stays but is unused).
