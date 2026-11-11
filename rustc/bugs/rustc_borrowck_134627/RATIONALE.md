# Adapted injection for Avoid ICE in borrowck

Fix: https://github.com/rust-lang/rust/commit/70fe5a150d2aa28e704a30a6ce8c2219e4b98583

# Rationale
Hunk: compiler/rustc_borrowck/src/region_infer/mod.rs, `constraint_path_between_regions`.
Re-expresses fix hunk `@@ -1945,8 +1945,14 @@ best_blame_constraint`, which added an `.or_else(...)` fallback searching for a path to the unnameable placeholder (`cannot_name_placeholder`) before the `.unwrap()`.
In 1.99.1 the code was restructured: `best_blame_constraint` does `constraint_path_between_regions(..).unwrap()`, then redirects to the unnameable placeholder. The primary search now passes `include_placeholder_static = true`; I changed it to `false`. The path via the placeholder edges is no longer found, there is no fallback, and the `.unwrap()` panics (the original ICE).
