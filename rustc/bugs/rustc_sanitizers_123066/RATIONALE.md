# Adapted injection for CFI: Pad out associated type resolution with erased lifetimes

Fix: https://github.com/rust-lang/rust/commit/70e1d23895f861ef6c3d936a91dd5f31e4ca0a40

# Rationale
File: compiler/rustc_sanitizers/src/cfi/typeid/itanium_cxx_abi/transform.rs, function `implemented_method` (the helper computing `vtable_possible`; formerly inline in `typeid_for_instance`).

Removed `&& tcx.is_dyn_compatible(trait_id)` from `vtable_possible`. This re-expresses the fix hunk
`@@ -1124,7 +1124,10 @@ pub fn typeid_for_instance` which added `&& tcx.object_safety_violations(trait_id).is_empty()`
(object_safety_violations is now `is_dyn_compatible`). Without it, methods of non-dyn-compatible traits
(e.g. GAT traits) go through `trait_object_ty` and ICE (issue 123053).
