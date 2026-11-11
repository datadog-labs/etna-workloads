# Adapted injection for Ambiguous Self lifetimes: don't elide.

Fix: https://github.com/rust-lang/rust/commit/8d1958f0d27f2a3393f2d6fde9560356c78b5f60

# Rationale
All in compiler/rustc_resolve/src/late.rs.

1. `find_lifetime_for_self` / `FindReferenceVisitor::visit_ty` — re-expresses fix hunk
   `@@ -2185,9 +2188,11 @@ ... impl Visitor for SelfVisitor`
   (`-if let TyKind::Ref(lt, ref mt) = ty.kind && self.is_self_ty(&mt.ty)` / `+if self.is_self_ty(ty) {self_found=true}; if let TyKind::Ref(lt, _)`).
   Reverted to only considering references whose referent is immediately Self (`is_self_ty(&mt.ty)`), instead of any reference containing Self anywhere.
2. `resolve_fn_params`, self handling — re-expresses hunk `@@ -2132,13 +2132,15 @@` (`Set1::Many => Elision::None`, vs. old: ambiguity not treated as special). Here `Set1::Many` now maps to `Elision::None` (falls back to other param candidates) instead of `Elision::Err`.
