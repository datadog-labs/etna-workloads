# Adapted injection for Don't inherit codegen attrs from parent static

Fix: https://github.com/rust-lang/rust/commit/4ff8a9bd6b64e32703603cf8bc8cb5cb221d4889

compiler/rustc_const_eval/src/interpret/intern.rs, `intern_as_new_static`: re-expresses hunk `@@ -106,13 +107,17 @@ fn intern_as_new_static`. The fix replaced `feed.codegen_fn_attrs(tcx.codegen_fn_attrs(static_id).clone())` with `feed.codegen_fn_attrs(CodegenFnAttrs::new())`. I restored the old line, so nested allocations inherit the parent's `#[no_mangle]` and `export_name`. I also removed the now-unused `CodegenFnAttrs` import, which re-expresses the first hunk (`@@ -18,6 +18,7 @@`).
