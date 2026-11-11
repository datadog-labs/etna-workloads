# Adapted injection for Typo suggestion to change bindings with leading underscore

Fix: https://github.com/rust-lang/rust/commit/b0d17f35d98c5cafd43a673c70f8ab5d393c31a3

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs (suggestion emission, formerly diagnostics.rs).
Fix hunk `@@ -1511,9 +1511,22 @@` added `let (span, sugg, post) = if let SuggestionTarget::SimilarlyNamed = suggestion.target && ... strip_prefix("_") && snippet == candidate {change the binding definition}`. In 1.99.1 the same branch exists; I added `&& false` so the branch never fires, restoring the pre-fix behaviour (suggest `_x` at the use site).
