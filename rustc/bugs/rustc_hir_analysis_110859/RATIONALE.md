# Adapted injection for Explicitly reject negative and reservation drop impls

Fix: https://github.com/rust-lang/rust/commit/bd146c72ac2faf6bbf189ad92d06e0bcd6cc92fc

# Rationale
File: compiler/rustc_hir_analysis/src/check/always_applicable.rs, fn `check_drop_impl` (moved from check/dropck.rs in 1.99.1).
Removed the `match tcx.impl_polarity(drop_impl_did) { Positive => {}, Negative => return Err(emit_err(DropImplPolarity::Negative..)), Reservation => ... }` block.
Re-expresses fix hunk `@@ -27,6 +29,19 @@ use rustc_middle::ty::{self, Predicate, Ty, TyCtxt};` in dropck.rs, which added that exact match. Negative/reservation Drop impls are no longer rejected.
The messages/errors definitions are left (now unused), matching the pre-fix state in effect. The util.rs hunk was only a reformat.
