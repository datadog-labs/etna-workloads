# Adapted injection for const-eval: disable pointer fragment support

Fix: https://github.com/rust-lang/rust/commit/aed0ed4c93d661fc7b66dc4a39690948476e8a4a

# Rationale
In 1.99.1 the fix for #146291 (aed0ed4) was superseded by a real implementation: `PointerFrag` carries the
pointer's `bytes`, and fragments are only merged if provenance, `bytes` and `idx` all match. The fix diff's
hunks (`@@ -137 ... merge_bytes`: `if !Prov::OFFSET_IS_ADDR { // FIXME(#146291): We need to ensure that we don't mix different pointers with the same provenance`) guarded against exactly that mixing. Re-injection restores the parent's behaviour of mixing fragments of different pointers with the same provenance:

File compiler/rustc_middle/src/mir/interpret/allocation/provenance_map.rs
- `merge_bytes`: removed `frag.bytes == first_frag.bytes` check, so fragments of different pointers with same provenance get merged into a whole pointer.
- `read_ptr`: compare only `frag.prov` (not `(prov, bytes)`) with expectation (plus a type annotation on `expected`).
Both re-express the fix hunks that made reading/copying/merging mixed fragments an error (`ReadPartialPointer`, "ensure that we don't mix different pointers with the same provenance").
