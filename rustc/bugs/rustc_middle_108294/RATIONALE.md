# Adapted injection for Place binder correctly for arbitrary trait bound suggestion

Fix: https://github.com/rust-lang/rust/commit/16e2b9f66201e0d0437028842c3e565424cd5fc6

File: compiler/rustc_middle/src/ty/diagnostics.rs, fn suggest_arbitrary_trait_bound.
- Hunk `@@ -117,7 +117,7 @@`: `let mut constraint = trait_pred.to_string();` reverted to printing only modifiers+trait path of the binder-skipped predicate (`trait_pred.skip_binder().print_modifiers_and_trait_path().to_string()`), so the `for<'a>` binder is lost. Added `use crate::ty::print::PrintTraitPredicateExt as _;` (trait now needs importing; method lives on unbound TraitPredicate in 1.99).
- Hunk `@@ -144,7 +144,7 @@`: `format!("{} {constraint}", ...)` reverted to `format!("{} {}: {}", where_or_comma, param_name, constraint)`, producing `where &T: Bar` without binder.
