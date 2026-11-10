# Adapted injection for Stop compiling when we get load crate failure

Fix: https://github.com/rust-lang/rust/commit/0f603290db0f8010a58ebae4e8699035f0ad3831

# Rationale
Only hunk changed: compiler/rustc_metadata/src/creader.rs, `CStore::resolve_crate` Err arm.
Fix hunk 4 `@@ -723,6 +731,9 @@ ... Err(err) =>` added
`if !tcx.sess.dcx().has_errors().is_some() { self.has_crate_resolve_with_fail = true; }`.
In 1.99.1 that condition had an extra `&& !span.is_dummy()` (ignore compiler-injected prelude loads), a later refinement.
I removed it (and its comment), so injected std/prelude load failures set the flag again, making resolve abort early
and suppress the later `#[panic_handler]`/unwinding errors (the empty-extern-arg case).
The other fix hunks (field, accessor, imports.rs abort) are already present in 1.99.1 and unchanged.
