# Adapted injection for mGCA: Make traits with type assoc consts dyn compatible...

Fix: https://github.com/rust-lang/rust/commit/8d524f096db5ab28defe57d37f95d2ec2f0d0324

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, fn dyn_compatibility_violations_for_assoc_item (AssocKind::Const arm).

Re-expresses the fix hunk `@@ -306,24 +307,35 @@ fn generics_require_sized_self` which introduced
`if tcx.features().min_generic_const_args() { ...GenericAssocConst / NonTypeAssocConst / Vec::new() }`
(type assoc consts permitted, to be specified via bindings) instead of the old unconditional
`vec![DynCompatibilityViolation::AssocConst(..)]`. In 1.99.1 the gate is `if tcx.features().min_generic_const_args()`;
I changed it to `if false`, so every assoc const is always a dyn-compat violation (old behaviour: assoc consts never dyn compatible).
The other fix hunks (renames, dyn_trait.rs ordering of consts, sty.rs count) were not reverted; with consts never reaching them they are inert.
