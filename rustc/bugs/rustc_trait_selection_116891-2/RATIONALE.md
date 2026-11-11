# Adapted injection for except equal parameters from the uniqueness check

Fix: https://github.com/rust-lang/rust/commit/4ecdf5ff00a9af18160bc7214cbcb8a6a1e01d10

File: compiler/rustc_trait_selection/src/opaque_types.rs (the fix's compiler/rustc_borrowck/src/region_infer/opaque_types.rs logic moved here), function `opaque_types_defined_by`'s param check (non-defining-use check).
1. Removed `|| (lt.is_static() && opaque_env.param_equal_static(i))` — re-expresses fix hunk `@@ -451,6 +456,7 @@ fn check_opaque_type_parameter_valid` (added that line).
2. Replaced the guarded push with `seen_params.entry(arg).or_default().push(i);` — re-expresses fix hunk `@@ -460,7 +466,13 @@` (old line `seen_params.entry(arg).or_default().push(i);`), so equal params are no longer excepted from uniqueness.
