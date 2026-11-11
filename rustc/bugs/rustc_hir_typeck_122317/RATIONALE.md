# Adapted injection for Use sup instead of eq when unifying self type

Fix: https://github.com/rust-lang/rust/commit/8995c2c4a20197358605c3dad609e39f90a75ce8

# Rationale
File: compiler/rustc_hir_typeck/src/method/probe.rs, fn `consider_probe` (3 hunks, one per candidate kind: InherentImplCandidate, ObjectCandidate/TraitCandidate, WhereClauseCandidate).
Fix hunks (@@ -1376, -1437, -1489) changed `self.at(..).eq(DefineOpaqueTypes::No, xform_self_ty, self_ty)` to `.sup(...)`.
In 1.99.1 this became `ocx.relate(cause, param_env, self.variance(), self_ty, xform_self_ty)` where variance is Covariant for method calls (the sup behaviour). I pass `ty::Invariant` at the three self-type relate calls, restoring the old eq (invariant) unification. The return-type relate is untouched.
