# Adapted injection for CFI: Fix methods as function pointer cast

Fix: https://github.com/rust-lang/rust/commit/8e6b4e91b68a0921c534aa1174d27f3c6418b1e6

# Hunk: compiler/rustc_codegen_llvm/src/declare.rs, CodegenCx::declare_fn
Removed `cfi::TypeIdOptions::USE_CONCRETE_SELF` (1.99.1 name of the fix's `NO_SELF_TYPE_ERASURE`) from the option list whose powerset is emitted as type metadata for instances.
Re-expresses fix hunk `@@ -141,33 +143,31 @@ impl<'ll, 'tcx> CodegenCx` which added `TypeIdOptions::NO_SELF_TYPE_ERASURE` to the powerset loop, so methods get a secondary type id with concrete self. Without it, methods only have the erased-self id and cannot be called through fn pointers under CFI.
The typeid.rs / itanium hunks already exist in 1.99.1 (flag and its use in transform.rs) and are left intact.
