# Adapted injection for CFI: Fix SIGILL reached via trait objects

Fix: https://github.com/rust-lang/rust/commit/7c7b22e62cd3aa34ef60ec98b145258caa55261f

# Re-injection
File: compiler/rustc_sanitizers/src/cfi/typeid/itanium_cxx_abi/transform.rs, fn `transform_instance`.
In 1.99.1 the fix's logic (`typeid_for_instance` in typeid_itanium_cxx_abi.rs, hunk `@@ -1010,3 +1010,56 @@`:
"If this instance is a method ... Transform the concrete self into a reference to a trait object") lives in
the `if let Some((trait_ref, method_id, ancestor)) = implemented_method(tcx, instance)` branch, which rewrites
the concrete self into a trait object for trait-impl methods. I made that branch only fire when
`USE_CONCRETE_SELF` is set (contradicting the enclosing `!contains`), so it never fires: declarations of trait
methods get typeids with concrete self, not matching dyn call sites (the original SIGILL bug).
