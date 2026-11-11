# Adapted injection for repr_transparent_external_private_fields: treat `rustc_pub_transparent` types as local

Fix: https://github.com/rust-lang/rust/commit/06f2d73b2bd6f290a72d8041c957a08b3f6d50c7

compiler/rustc_hir_analysis/src/check/check.rs, check_transparent (check_non_exhaustive, ty::Adt arm).
Fix hunk `@@ -1259,7 +1259,8 @@ check_transparent`: `if !def.did().is_local()` became `if !def.did().is_local() && !tcx.has_attr(def.did(), sym::rustc_pub_transparent)`.
In 1.99.1 the attr check is `find_attr!(tcx, def.did(), RustcPubTransparent(_))`; I removed it, so rustc_pub_transparent types are no longer treated as local.
