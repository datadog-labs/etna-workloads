# Adapted injection for Bubble up opaque <eq> opaque operations instead of picking an order

Fix: https://github.com/rust-lang/rust/commit/930affa39d7902e57a830e328754ce546c992608

# Rationale

1.99.1 no longer has `DefiningAnchor::Bubble`, `AliasRelate` handling in the old solver's
fulfill/select, or the `check_opaque_type_well_formed` code from fix.diff, so those hunks have no
direct counterpart. The fix's core hunk is in `rustc_infer/src/infer/opaque_types`:
`@@ -145,7 +145,25 @@ ... DefiningAnchor::Bubble => { if let ty::Alias(ty::Opaque, _) = b.kind() { ...AliasRelate... return Some(Ok(...)) } }`.
Its purpose: when both sides are opaque types and we don't know which may define the other,
do NOT pick an order; bubble the obligation up. The bug is that an order gets picked.

Changes, both in `compiler/rustc_infer/src/infer/opaque_types/mod.rs`, `handle_opaque_type`:
1. Inside `process`, the `if !self.can_define_opaque_ty(def_id) { return None; }` guard is skipped
   when `b` is also an opaque type. Any opaque (even one outside the defining scope) may then take
   the other as its hidden type. This re-creates the pre-fix "either opaque may be the defining one" behaviour.
2. In the final dispatch, if both sides are opaque, `process(b, a)` is tried before `process(a, b)`,
   i.e. a fixed order is picked instead of bubbling up the equality. That is the "picking an order"
   of the fix's subject line.
