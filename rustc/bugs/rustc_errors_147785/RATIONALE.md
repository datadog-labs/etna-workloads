# Adapted injection for fix: Use untrimmed line numbers for trimmed suggestions

Fix: https://github.com/rust-lang/rust/commit/ad67c9d581b7de937398ddea8671d41c9a96dfa0

# Rationale
In 1.99.1 the human emitter was replaced by annotate-snippets (`annotate_snippet_emitter_writer.rs`); trimming happens in the renderer, and `TrimmedSubstitutionPart.original_span` is unused.

1. `compiler/rustc_errors/src/annotate_snippet_emitter_writer.rs`, suggestion rendering (`spans` passed to `shrink_file`, which computes the first displayed line number): now computes spans trimmed via `as_substr` (prefix/suffix removed) instead of the original part spans. Re-expresses emitter.rs hunk `@@ -2154,11 +2154,11 @@`: `-let line_start = sm.lookup_char_pos(parts[0].original_span.lo()).line;` reverted to `parts[0].span.lo()` (trimmed span), i.e. line numbers come from trimmed spans.
2. `compiler/rustc_errors/src/lib.rs`: `as_substr` made `pub(crate)` so the emitter can use it (supports hunk 1; relates to the `trim_trivial_replacements` hunks).
