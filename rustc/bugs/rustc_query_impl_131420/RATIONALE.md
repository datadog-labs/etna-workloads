# Adapted injection for Dont ICE when encountering post-mono layout cycle error

Fix: https://github.com/rust-lang/rust/commit/17eca60c2432d4b140ec0dca441cc6fde6562698

# Rationale
Hunk: compiler/rustc_query_impl/src/handle_cycle_error.rs, `layout_of` cycle handler.
In 1.99.1 `LayoutError::Cycle` no longer exists and the layout_of cycle handler emits the error and calls `raise_fatal()`, so codegen's `handle_fn_abi_err` (the fix's hunk `@@ -1187,10 +1187,11 @@ ... FnAbiOfHelpers for CodegenCx`, which added `LayoutError::Cycle(_)` to the `emit_fatal` arm) is never reached for cycles.
Re-expression: the handler now emits the diagnostic and returns `Err(LayoutError::ReferencesError(guar))`. A post-mono cycle thus reaches `handle_fn_abi_err`, whose fatal arm lists only `SizeOverflow | InvalidSimd`, falling to `span_bug!` — the pre-fix ICE ("Dont ICE when encountering post-mono layout cycle error").
