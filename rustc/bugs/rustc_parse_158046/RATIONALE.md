# Adapted injection for Preserve file module spans for inner attributes

Fix: https://github.com/rust-lang/rust/commit/daff59158e95f7616592ef4f48b7b9d14a50cfc2

# Rationale
Only hunk changed: compiler/rustc_parse/src/lib.rs, `fake_token_stream_for_item`.
Re-expresses fix hunk `@@ -251,12 +251,77 @@ pub fn parse_in`, which added
`if let Some(tokens) = fake_token_stream_for_file_mod(psess, item, attr_to_exclude) { return tokens; }`.
Removing that early return restores the old behaviour: file modules with inner attributes go through the
pretty-printed fake token stream, losing real file spans. The param is renamed `_attr_to_exclude` and
`fake_token_stream_for_file_mod` gets `#[allow(dead_code)]` to keep the build warning-free. expand.rs callers left unchanged (they still compile).
