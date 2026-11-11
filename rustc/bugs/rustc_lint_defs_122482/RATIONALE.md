# Adapted injection for Ungate the `UNKNOWN_OR_MALFORMED_DIAGNOSTIC_ATTRIBUTES` lint

Fix: https://github.com/rust-lang/rust/commit/25411113c1185bd08841bbedeb4e52279f8e5f13

# Rationale
File: compiler/rustc_lint_defs/src/builtin.rs, `declare_lint!` for `UNKNOWN_DIAGNOSTIC_ATTRIBUTES`.
In 1.99.1 the old `UNKNOWN_OR_MALFORMED_DIAGNOSTIC_ATTRIBUTES` lint was split; the unknown-attribute part is `UNKNOWN_DIAGNOSTIC_ATTRIBUTES` (grouped as `unknown_or_malformed_diagnostic_attributes`).
I re-added `@feature_gate = diagnostic_namespace;`, which re-expresses the fix hunk
`@@ -4341,7 +4341,6 @@ declare_lint! { pub UNKNOWN_OR_MALFORMED_DIAGNOSTIC_ATTRIBUTES ...` that removed `-    @feature_gate = sym::diagnostic_namespace;`.
The feature is long stable, so the lint is wrongly treated as gated and `#![deny(unknown_or_malformed_diagnostic_attributes)]` no longer takes effect.
