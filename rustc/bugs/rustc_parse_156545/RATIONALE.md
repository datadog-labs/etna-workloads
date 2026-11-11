# Adapted injection for fix issue-144595

Fix: https://github.com/rust-lang/rust/commit/92194469a07a150a96e1e9ee8672424bcbf7bc7c

Hunk: compiler/rustc_parse/src/parser/item.rs, `parse_tuple_struct_body` (imports + body).
In 1.99.1 the errors live in diagnostics.rs and the fix's code is already present. Re-injected the pre-fix behaviour
(no diagnostics for field names in tuple structs): removed `openparen_span`/`encountered_colon` tracking and the
`.map_err(...)` adding UseDoubleColonSuggestion / UseRegularStructSuggestion, plus the now-unused imports.
Corresponds to fix hunks `@@ -2084,10 +2087,11 @@`, `@@ -2109,6 +2113,8 @@` and `@@ -2156,6 +2162,19 @@` (the `.map_err(|mut error| { if encountered_colon {...` block).
