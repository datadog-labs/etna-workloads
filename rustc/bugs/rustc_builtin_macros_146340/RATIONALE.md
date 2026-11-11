# Adapted injection for Strip frontmatter in fewer places

Fix: https://github.com/rust-lang/rust/commit/7a66925a8138df105f77d646f9206024baf7ea4b

# Rationale
compiler/rustc_builtin_macros/src/source_util.rs, `ExpandInclude::make_expr` (inside `expand_include`):
the parser is created with `StripTokens::ShebangAndFrontmatter` instead of the fixed-version's no-frontmatter stripping.
Re-expresses hunk `@@ -114,39 +116,48 @@ expand_include` where make_expr's `new_parser_from_file(..., StripTokens::Shebang, Some(self.span))`
("Don't strip frontmatter for backward compatibility, `---` may be the start of a manifold negation") replaced the
old behaviour of always stripping frontmatter (parser built with ShebangAndFrontmatter). 1.99.1 already uses `StripTokens::Nothing` there, so the one-line change restores the bug.
