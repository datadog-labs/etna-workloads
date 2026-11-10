# Adapted injection for use `PatKind::error` when an ADT const value has violation

Fix: https://github.com/rust-lang/rust/commit/223674a824317284b42ba197be43fd68b957ab58

# Rationale
File: compiler/rustc_mir_build/src/thir/pattern/const_to_pat.rs, `valtree_to_pat`, the `ty::Adt(..) if !self.type_marked_structural(ty)` arm.
Fix hunk (`@@ -198,6 +198,14 @@ impl<'tcx> ConstToPat<'tcx>`) added `let kind = PatKind::Error(e); return Box::new(Pat {.. kind })` after emitting `TypeNotStructural` for an ADT const with a violation. In 1.99.1 this is `return self.mk_err(...)`, which yields `PatKind::Error`. I re-introduced the old behaviour: the error is emitted but a non-error pattern (`PatKind::Wild`) is returned, so follow-up diagnostics are not silenced.
