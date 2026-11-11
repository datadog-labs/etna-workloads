# Adapted injection for CFI: Rewrite `FnPtrShim` when generalizing

Fix: https://github.com/rust-lang/rust/commit/20d3d576d574bc38c7ea38caf821f923abe31cc9

# Hunk: compiler/rustc_sanitizers/src/cfi/typeid/itanium_cxx_abi/transform.rs, fn default_or_shim
Removed the `ty::InstanceKind::Shim(ty::ShimKind::FnPtr(def_id, _))` arm (1.99.1 name of `FnPtrShim`) from the match, so only `Item` is handled.
Re-expresses fix hunk `@@ -459,6 +458,30 @@ transform_instance` (`ty::InstanceKind::Item(def_id) | ty::InstanceKind::FnPtrShim(def_id, _) => ...`). Without it, FnPtr shims are not rewritten to the trait method when generalizing, so the Fn::call via dyn vtable gets a CFI mismatch.
