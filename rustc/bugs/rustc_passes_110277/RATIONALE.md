# Adapted injection for refactor: emit "unused assoc fn" in lexical order

Fix: https://github.com/rust-lang/rust/commit/03cf0e949fc1537f4a626eb0a925f23cb9010cb3

# Rationale
File: compiler/rustc_passes/src/dead.rs, fn `lint_dead_codes` (was `check_mod_deathness` upstream).

Fix hunk `@@ -836,6 +836,13 @@ fn check_mod_deathness` added, inside the item loop, handling of `ItemKind::Impl` so impl
assoc items are linted in lexical order with the other items; hunk `@@ -900,10 +907,6 @@` removed the separate
`for impl_item in module_items.impl_items() { visitor.check_definition(..) }` loop that ran after all items.
In 1.99.1 the in-loop handling is the `warn_multiple(.., "used", dead_codes, ..)` for inherent impls. I re-created the
old behaviour by deferring the inherent-impl assoc-item diagnostics into `deferred_impl_items` and emitting them after
the item loop (before foreign items), so they come after other dead-code lints.
