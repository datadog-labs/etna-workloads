# Adapted injection for identity uses are ok, even if there are no defining uses

Fix: https://github.com/rust-lang/rust/commit/381b3267aeebf1b3b6d400af6b9b0f2cc62ba390

File: compiler/rustc_borrowck/src/region_infer/opaque_types/mod.rs, fn apply_definition_site_hidden_types.
Fix hunk `@@ -503,7 +503,16 @@ apply_computed_concrete_opaque_types` replaced `assert!(tcx.use_typing_mode_borrowck(), "non-defining use in defining scope")`
with a check that `continue`s for identity uses (hidden type is the same opaque alias with the same args).
Re-injected: removed the identity-use `continue` branch and restored the plain assert (on the renamed `use_typing_mode_post_typeck_until_borrowck`), so identity uses with no defining uses ICE.
