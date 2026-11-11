# Adapted injection for Display short types for unimplemented trait

Fix: https://github.com/rust-lang/rust/commit/c0ce0f3c3feede6f6f98ecb4d0c42668dd4f5afe

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/on_unimplemented.rs, fn `format_args`-style generic_args builder (the code moved from on_unimplemented.rs / OnUnimplementedFormatString in 1.99.1).
In the type-param branch, `self.tcx.short_string(ty, long_ty_path)` is replaced by `ty.to_string()`, so the generic arg values used by on_unimplemented messages (e.g. `{Self}`) are full, non-shortened types.
Re-expresses fix hunk `@@ -824,7 +825,11 @@ impl<'tcx> OnUnimplementedFormatString`: `-trait_ref.args[..].to_string()` / `+tcx.short_ty_string(ty, &mut None)`.
The suggestions.rs hunk (return-type ty_to_string) was not needed/touched.
