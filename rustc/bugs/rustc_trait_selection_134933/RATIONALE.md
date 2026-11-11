# Adapted injection for Make sure we check the future type is Sized in AsyncFn*

Fix: https://github.com/rust-lang/rust/commit/ed9a4cfdeb0c81f26c7f6d8b8e56e36aa23cf420

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/confirmation.rs, fn `confirm_async_closure_candidate`.
Removed the `Sized` obligation on the future output type (`nested.push(... sized_trait_def_id ...)`) in both the
`ty::FnDef | ty::FnPtr` arm and the `ty::Closure` arm. This re-expresses fix hunks
`@@ -907,7 +911,7 @@` / `@@ -915,6 +919,13 @@` (FnDef/FnPtr arm) and `@@ -928,14 +939,20 @@` (Closure arm), which added
`let sized_trait_def_id = ...; nested.push(... [output_ty])`. Comments left as-is.
