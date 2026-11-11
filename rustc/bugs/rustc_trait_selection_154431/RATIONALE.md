# Adapted injection for avoid ICE in explicit reference cast suggestion for unrelated leaf predicates

Fix: https://github.com/rust-lang/rust/commit/741a3a7fc466df22e50f2b8d7dc697d22c8bdd41

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/fulfillment_errors.rs, fn report_selection_error (E0277 branch).
Re-expresses the single fix hunk `@@ -285,14 +285,16 @@`:
- removes the `leaf_trait_def_id` check (`&& (is_diagnostic_item(From, leaf..) || TryFrom ..)`), so unrelated leaf predicates (e.g. `Output<'a>`) enter the cast-suggestion path;
- replaces the safe `args.get(1).and_then(|a| a.as_type())` with the old `args.len() > 1` + `args.type_at(1)`, which ICEs when arg 1 is a lifetime;
- uses `skip_binder()` (as in the old code) instead of `no_bound_vars()`.
