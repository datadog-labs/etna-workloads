# Adapted injection for don't suggest turning crate-level attributes into outer style

Fix: https://github.com/rust-lang/rust/commit/22aa104bce457e7d70b05d7a32cdf09f25ac06b1

# Rationale
File compiler/rustc_parse/src/parser/attr.rs, fn `annotate_following_item_if_applicable`: the fix's hunk
`@@ -176,16 +182,18 @@` wrapped the `err.span_suggestion_verbose(... change inner to outer ...)` in `if suggest_to_outer { ... }`.
Re-injected bug: condition changed to `if suggest_to_outer || true`, so the inner->outer suggestion is emitted again
for crate-level-only attributes (e.g. `#![feature]`, `#![recursion_limit]`), as before the fix. The `suggest_to_outer` plumbing
(other hunks) is left in place but ineffective.
