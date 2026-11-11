# Adapted injection for Check ADT fields for copy implementations considering regions

Fix: https://github.com/rust-lang/rust/commit/8cf7f40a895f476ecd3216b11ff673389135b652

# Rationale
File: compiler/rustc_trait_selection/src/traits/misc.rs, fn `all_fields_implement_trait` (the 1.99.1 successor of `can_type_implement_copy`'s per-field loop).

Removed the per-field region check (`infcx.resolve_regions(...)` pushing `InfringingFieldsReason::Regions`). This re-expresses the fix hunk `@@ -63,21 +70,36 @@ pub fn can_type_implement_copy`, which added `infcx.process_registered_region_obligations(...)` and `if !infcx.resolve_regions(&outlives_env).is_empty() { infringing.push((field, ty)); }`. Before the fix, only `type_is_copy_modulo_regions` was used, so region constraints (e.g. `Foo<'static>: Copy` needed for `Foo<'any>`) were ignored. The other fix hunks (renames, imports, lint `must_apply_modulo_regions`) are refactors with no behavioural counterpart needed.
