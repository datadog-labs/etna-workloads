# Adapted injection for Don't ICE when computing ctype's repr_nullable_ptr for possibly-unsized ty

Fix: https://github.com/rust-lang/rust/commit/086cf346342263f3f53a7b1794fd7623f94d82fe

# Rationale
compiler/rustc_lint/src/types.rs, `repr_nullable_ptr`: replaced the fallible layout handling
(`field_ty_layout.is_err() && !has_non_region_param() => bug!`, then `.ok()?.backend_repr`) with
`tcx.layout_of(...).unwrap().backend_repr`. Re-expresses the fix hunk `@@ -923,7 +923,12 @@ repr_nullable_ptr`
(`let field_ty_abi = &tcx.layout_of(param_env.and(field_ty)).unwrap().abi;` was the old code), so an ICE occurs for `Option<&T>` with `T: ?Sized`.
