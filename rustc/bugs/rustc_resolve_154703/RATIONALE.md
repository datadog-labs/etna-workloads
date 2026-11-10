# Adapted injection for Increase span_look_ahead limit to handle whitespace

Fix: https://github.com/rust-lang/rust/commit/46b05279dd1c6c82ab1e850220fffb04531b9030

# Rationale
File: compiler/rustc_resolve/src/late/diagnostics.rs, fn add_missing_lifetime_specifiers_label, `MissingLifetimeKind::Comma` arm of `build_sugg`.

Re-expresses fix hunk `@@ -4074,9 +4075,12 @@` (removes the `intersperse(", ")` + `span_look_ahead(lt.span, ">", Some(50))` empty-brackets check, restoring `repeat_n([existing_name, ", "], lt.count).flatten()`), so `Foo<>` gets `Foo<'a, >` (trailing comma). Also removes the `let source_map = ...` from hunk `@@ -4064,6 +4064,7 @@`.
On 1.99.1 the helper is `span_followed_by` (span_look_ahead no longer exists), so the hunk was reversed by hand.
