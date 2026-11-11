# Adapted injection for Don't use AsyncFnOnce::CallOnceFuture bounds for signature deduction

Fix: https://github.com/rust-lang/rust/commit/88669aed22aeeef5fb7ecdb7f43ed33e674f8fcb

# Rationale
File: compiler/rustc_hir_typeck/src/closure.rs, fn `deduce_sig_from_projection`.
Re-expresses fix hunks `@@ -454,20 +454,16 @@` (and the second hunk at -475): replaces the
`projection.item_def_id()` + `is_lang_item(def_id, FnOnceOutput / AsyncFnOnceOutput)` checks with the old
`trait_def_id = projection.trait_def_id(tcx)` and `fn_trait_kind_from_def_id` / `async_fn_trait_kind_from_def_id(...).is_some()`
checks, so any projection on an AsyncFn* trait (e.g. `CallOnceFuture`) is used for signature deduction.
