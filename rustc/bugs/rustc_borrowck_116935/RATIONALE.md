# Adapted injection for Prevent opaque types being instantiated twice with different regions within the same function

Fix: https://github.com/rust-lang/rust/commit/be9317d1ec103e76e071589471fcb0bb76d4c908

# Rationale
One hunk: compiler/rustc_borrowck/src/region_infer/opaque_types/mod.rs, in the function that maps opaque type hidden types (the loop ending in `add_hidden_type`).
I removed the block that checks (via `decls_modulo_regions`) that opaque types with equal non-region args have equal region args, and pushes `DeferredOpaqueTypeError::LifetimeMismatchOpaqueParam`.
This re-expresses the fix's added `check_unique` function and its call `self.check_unique(infcx, &opaque_ty_decls);` (hunk `@@ -65,6 +125,8 @@` in region_infer/opaque_types.rs, plus the `borrowck_opaque_type_lifetime_mismatch` diagnostic). Without it, an opaque type can be instantiated twice with different regions in one function.
