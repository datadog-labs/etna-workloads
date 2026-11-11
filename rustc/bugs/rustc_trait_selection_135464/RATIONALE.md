# Adapted injection for fix ICE with references to infinite structs in consts

Fix: https://github.com/rust-lang/rust/commit/7a3c4f73ae165b7087ab9f03f11ce3b4006d1498

# Rationale
File: compiler/rustc_trait_selection/src/traits/project.rs, fn assemble_candidates_from_impls (Pointee::Metadata builtin candidate).
Re-expresses both hunks of fix.diff in reverse:
- `@@ -1148,7 +1148,9 @@`: removed `| ty::Error(..) => true` ("reached the recursion limit when finding the struct tail") from the unit-metadata (known Sized) arm.
- `@@ -1179,8 +1181,7 @@`: put `| ty::Error(_)` back in the Param/Alias/Bound/Placeholder/Infer arm, so an error tail yields rigid/non-unit metadata (the ICE in #114484 at monomorphization).
