# Adapted injection for check RPITs for invalid args

Fix: https://github.com/rust-lang/rust/commit/ce91e46a1e9ad5126df1128068113d6f2d618827

# Rationale
File: compiler/rustc_trait_selection/src/opaque_types.rs, fn `opaque_type_has_defining_use_args` (the 1.99.1 home of the old `check_opaque_type_parameter_valid` in rustc_borrowck/region_infer/opaque_types.rs).

The fix hunks `@@ -441,12 +441,6 @@` (removed `is_ty_alias` computation from the opaque's origin) and `@@ -454,14 +448,10 @@` (`GenericArgKind::Lifetime(lt) if is_ty_alias =>` became `GenericArgKind::Lifetime(lt) =>`, and removed `GenericArgKind::Lifetime(_) => continue` with the FIXME(#113916)) are reversed. I recompute `is_ty_alias` from `local_opaque_ty_origin`, and add `GenericArgKind::Lifetime(_) if !is_ty_alias => continue`. Lifetime args of RPITs are therefore unchecked again, and only TAITs are checked.
