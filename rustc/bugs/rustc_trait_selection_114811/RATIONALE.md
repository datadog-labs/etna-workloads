# Adapted injection for Show more information when multiple `impl` apply

Fix: https://github.com/rust-lang/rust/commit/2817ece19c67a182c0b0aae402c0e57c8ed22dab

Both hunks are in compiler/rustc_trait_selection/src/error_reporting/traits/ambiguity.rs. The upstream code lived in error_reporting/mod.rs, which no longer exists in 1.99.1.

1. `applicable_impls_to_mention`: I removed the block that filters out impls with type params once there are many candidates. It re-expresses the fix hunk `@@ -2366,14 +2367,28 @@`, which added `if ambiguities.len() > 20 { ... ambiguities.retain(...) }`. In 1.99.1 that block reads `> 5` and uses `generics_of(..).count() == 0`. I also dropped the `mut` on `ambiguities`.
2. The `impl_candidates.len() < 40` check in the E0283 reporting path is back to `< 10`. This re-expresses the fix hunk `@@ -2392,7 +2407,7 @@`, which changed `< 10` to `< 40`.
