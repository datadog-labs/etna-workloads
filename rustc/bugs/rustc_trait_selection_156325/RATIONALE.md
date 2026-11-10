# Adapted injection for Don't treat const param default as projection

Fix: https://github.com/rust-lang/rust/commit/5148dacbb8c21eb60499513fd8456db23e6ba22a

# Rationale
File: compiler/rustc_trait_selection/src/traits/dyn_compatibility.rs, `IllegalSelfTypeVisitor::visit_const`.

Fix hunk `@@ -867,7 +867,8 @@ impl<'tcx> TypeVisitor<TyCtxt<'tcx>> for IllegalSelfTypeVisitor<'tcx>`
added `matches!(self.tcx.def_kind(proj.def), DefKind::AssocConst { .. }) &&` before the
`tcx.parent(proj.def)` / `def_kind(trait_def_id) == Trait` guard.

In 1.99.1 the arm only matched `AliasConstKind::Projection`, so the fix's check is implied by the pattern. I re-introduced the bug by matching any alias const kind (`kind.opt_def_id()`) and keeping only the parent-is-Trait check. A const param default anon const is then treated as a trait projection and `TraitRef::from_assoc` gets mismatched args, giving an ICE.
