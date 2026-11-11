# Adapted injection for improve help for multiple `#[default]` variants

Fix: https://github.com/rust-lang/rust/commit/f697a00f760c17547ef4282fd6af5b9f3c433dcf

# default.rs, `extract_default_variant` (multiple-defaults arm)
Reverts hunk `@@ -127,18 +127,17 @@ fn extract_default_variant`: restores the old `.map(|variant| ...)` that
filters other variants by `v.span == variant.span` and takes only the first `#[default]` attr
(`find_by_name`) of each, instead of `filter_map` + `filter_by_name` comparing attr spans
(`attr.span != keep`) and dropping empty suggestions. Same-span variants (macro-generated) yield
wrong/empty suggestions (the original ICE), and duplicate `#[default]` attrs on one variant are not covered.
