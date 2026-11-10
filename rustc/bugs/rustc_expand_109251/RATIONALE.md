# Adapted injection for Suggest surrounding the macro with `{}` to interpret as a statement

Fix: https://github.com/rust-lang/rust/commit/550e3087d1b521f2b3b669ebaaf6d16e4c593fca

# Rationale
File: compiler/rustc_expand/src/mbe/diagnostics.rs, fn emit_frag_parse_err.
Fix hunk `@@ -245,12 +245,24 @@ pub(super) fn emit_frag_parse_err(` added a `if parser.token == token::Semi` branch suggesting
`{ snippet; }` ("surround the macro invocation with `{}`..."). Re-injected the parent behaviour: removed the branch and
always emit the "add `;` to interpret the expansion as a statement" suggestion at site_span.shrink_to_hi().
