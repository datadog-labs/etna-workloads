# Adapted injection for entirely ignore region errors in normalize_predicates

Fix: https://github.com/rust-lang/rust/commit/81ffc417903af1777123e353967613334259577b

# Hunk: compiler/rustc_trait_selection/src/traits/mod.rs, `do_normalize_clauses` (was do_normalize_predicates)
Fix hunk `@@ -287,17 +287,20 @@ fn do_normalize_predicates` replaced the `if !errors.is_empty() { span_delayed_bug(...) }` with
`let _errors = infcx.resolve_regions(...)`. Re-injected the old behaviour: region errors from resolve_regions
in normalization again emit a delayed bug ("failed region resolution while normalizing ...").
