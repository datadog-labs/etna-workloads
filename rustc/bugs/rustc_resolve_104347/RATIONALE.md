# Adapted injection for diagnostics: add `};` only if `{` was added too

Fix: https://github.com/rust-lang/rust/commit/e237690a28f0d38ab478616fe4b247fb6eb8013f

# Rationale
File: compiler/rustc_resolve/src/diagnostics/impls.rs (the import-suggestion function that builds `corrections`; was diagnostics.rs upstream).
Re-expresses fix hunks `@@ -2161,6 +2161,11 @@` and `@@ -2168,11 +2173,6 @@`: the fix moved the
`if !has_nested { corrections.push((end_point(after_crate_name), "};")) }` into the branch where `{` is added.
I moved it back after the if/else, so `};` is added even for the module-relative (`use m::x;`) case where no `{` was added.
