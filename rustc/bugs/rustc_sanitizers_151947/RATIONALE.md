# Adapted injection for Include assoc const projections in CFI trait object

Fix: https://github.com/rust-lang/rust/commit/990c55801ec129a1781c1b3915ff74bb85f9cdf1

# Rationale
File: compiler/rustc_sanitizers/src/cfi/typeid/itanium_cxx_abi/transform.rs, fn `trait_object_ty`.
Changed `.filter(|item| item.can_have_equality_constraint(tcx))` back to `.filter(|item| item.is_type())`.
Re-expresses fix hunk `@@ -243,24 +243,24 @@ fn trait_object_ty` which changed `.filter(|item| item.is_type())` to `.filter(|item| item.is_type() || item.is_const())`. (1.99.1 already generalized the rest of the hunk; the filter now covers assoc consts via can_have_equality_constraint.) Assoc const projections are again omitted from the CFI trait object.
