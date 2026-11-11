# Adapted injection for Paper over an accidental regression

Fix: https://github.com/rust-lang/rust/commit/02771849777ce072e5fc3af5a39fa2415124829b

# Rationale
File: compiler/rustc_hir_analysis/src/check/check.rs, fn check_opaque_meets_bounds.
Fix hunk `@@ -461,7 +461,15 @@ fn check_opaque_meets_bounds` added, for FnReturn/AsyncFn, a HACK that does
`let _ = infcx.take_opaque_types(); return Ok(());` skipping the hidden type identity check.
In 1.99.1 this is the `else if let FnReturn|AsyncFn = origin { ... take_opaque_types(); Ok(()) }` branch.
I removed that branch, so RPIT/async fn opaques go through the identity-based hidden-type check (sanity_check_found_hidden_type) again, restoring the regression.
