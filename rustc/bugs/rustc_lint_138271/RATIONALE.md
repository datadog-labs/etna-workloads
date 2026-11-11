# Adapted injection for Keep space if expr follows identifier when lint unused parens

Fix: https://github.com/rust-lang/rust/commit/9991ec282f3ff08c895e4a5262259139fe689953

# Rationale
File compiler/rustc_lint/src/unused.rs, fn `emit_unused_delims`: removed the two `else if` branches that
keep a space when the source before/after the parens is alphanumeric (`span_to_prev_source(value_span)` ends_with alphanumeric -> " ";
`span_to_next_source(value_span)` starts_with alphanumeric -> " "). Re-expresses both hunks of fix.diff
(`@@ -843,6 +843,10 @@` and `@@ -852,6 +856,10 @@`, which added those branches; code is at ~line 323 in 1.99.1).
