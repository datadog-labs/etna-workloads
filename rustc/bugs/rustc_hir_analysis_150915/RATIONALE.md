# Adapted injection for ensure generics are still properly reported on EII *implementations*, and test this

Fix: https://github.com/rust-lang/rust/commit/b454f76bd1ddf5c7459238f295647561a7895cbc

# Rationale
File: compiler/rustc_hir_analysis/src/check/compare_eii.rs, fn `check_is_structurally_compatible`.
Removed the call `check_no_generics(tcx, external_impl, declaration, eii_name, eii_attr_span)?;`
This re-expresses the fix hunk `@@ -154,11 +155,44 @@ fn check_is_structurally_compatible` which added that call.
`check_no_generics` is kept (with `#[allow(dead_code)]` to avoid unused warning), so EII impls with type params are no longer rejected.
