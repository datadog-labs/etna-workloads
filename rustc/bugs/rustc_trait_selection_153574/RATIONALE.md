# Adapted injection for add self-referential param-env normalization regression

Fix: https://github.com/rust-lang/rust/commit/d29c4895994dae92c6e8e47aec08fd4c81fb5d54

# Rationale
File: compiler/rustc_trait_selection/src/traits/mod.rs, fn do_normalize_clauses (1.99.1 successor of do_normalize_predicates).
Fix hunk `@@ -300,19 +300,14 @@ fn do_normalize_predicates`: replaced `span_bug!(span, "inference variables in normalized parameter environment: {}", fixup_err)` with `Err(tcx.dcx().span_delayed_bug(...))`.
In 1.99.1 the fallback delays a bug and replaces infer/alias with errors; I restored the old `span_bug!` ICE in the `Err(fixup_err)` arm of `fully_resolve`.
