# Adapted injection for Don't call extern_crate when local crate name is the same as a dependency and we have a trait error

Fix: https://github.com/rust-lang/rust/commit/9d5d03b7dec8a87c81528e9a1310313fa3f0111e

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/mod.rs, fn `extern_crates_with_the_same_name`.
Removed the early return `if expected_def_id.is_local() || trait_def_id.is_local() { return false; }`.
Re-expresses fix hunk `@@ -1669,6 +1669,7 @@` in fulfillment_errors.rs which added
`.filter(|def_id| def_id.krate != LOCAL_CRATE)` before `.filter_map(|def_id| self.tcx.extern_crate(def_id.krate))`.
In 1.99.1 that code moved; the equivalent guard is the local-crate check, which stops `extern_crate` being queried for the local crate.
Without it, a local crate sharing a name with a dependency produces the bogus "multiple versions" note.
