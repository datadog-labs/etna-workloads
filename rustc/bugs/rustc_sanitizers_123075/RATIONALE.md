# Adapted injection for CFI: Fix drop and drop_in_place

Fix: https://github.com/rust-lang/rust/commit/0b860818e6fe937f09680a6434a9d6b0e1e44dcb

# Rationale
File: compiler/rustc_sanitizers/src/cfi/typeid/itanium_cxx_abi/transform.rs, fn transform_instance.
The fix hunk `@@ -1112,8 +1112,36 @@ pub fn typeid_for_instance` added the branch
`if (Virtual && drop_in_place) || DropGlue { ... self_ty = dyn Drop ... }` before
`else if Virtual => strip_receiver_auto`. In 1.99.1 that code lives in transform_instance.
I disabled that branch (`if false { unreachable!() }`), so drop glue / drop_in_place are no longer
normalised to a `dyn Drop` self type, restoring the pre-fix behaviour.
