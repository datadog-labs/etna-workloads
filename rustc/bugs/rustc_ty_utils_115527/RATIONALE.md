# Adapted injection for Don't require `Drop` for `[PhantomData<T>; N]` where `N` and `T` are generic, if `T` requires `Drop`

Fix: https://github.com/rust-lang/rust/commit/320bb8116f136f4748787cf92178da9e7e5b2d91

# Rationale
File: compiler/rustc_ty_utils/src/needs_drop.rs

Functions `needs_drop_raw` and `has_significant_drop_raw`: removed the
`.filter(filter_array_elements(tcx, query.typing_env))` call from the `drop_tys_helper(...)` iterator chains.
This re-expresses fix.diff hunks `@@ -19,13 +19,32 @@ fn needs_drop_raw` (which added `.filter(filter_array_elements(tcx, query.param_env))`)
and `@@ -37,6 +56,7 @@ fn has_significant_drop_raw` (`+    .filter(filter_array_elements(tcx, query.param_env))`).
Without the filter, `[T; N]` with generic N is treated as needing drop even when the element does not.
`filter_array_elements` is kept with `#[allow(dead_code)]` to avoid an unused warning (the async variant still uses its own filter).
