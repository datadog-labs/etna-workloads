# Adapted injection for fix improper ctypes in Znext solver

Fix: https://github.com/rust-lang/rust/commit/dc14afd0fc0ab44f764777ec82198012cd442039

All in compiler/rustc_lint/src/types/improper_ctypes.rs (1.99.1 already contained the fix; I reverted all of its hunks).
1. `ImproperCTypesVisitor::new` — re-expresses hunk `@@ -468,12 +468,14 @@`: removed the `has_opaque_types()` skip; base_ty is always normalized again (new solver populates OpaqueTypeStorage -> delayed bug, #156352).
2. `visit_type` (match on ty kind) — re-expresses `@@ -894,6 +896,16 @@` / `-902,10 +914,6`: Closure/CoroutineClosure/Coroutine/CoroutineWitness removed from the FfiUnsafe arm, back in the `bug!("unexpected type in foreign function")` arm.
3. `check_type` — re-expresses `@@ -941,6 +949,11 @@`: removed the pre-normalization `visit_for_opaque_ty` check, so an async extern fn's opaque is revealed into a Coroutine.
