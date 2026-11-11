# Adapted injection for Make nll higher ranked equate use bidirectional subtyping in invariant context

Fix: https://github.com/rust-lang/rust/commit/0479287a38ccef11c84f694a9105de8120f6a6b4

# Rationale
File: compiler/rustc_borrowck/src/type_check/relate_tys.rs, fn `NllTypeRelating::binders`.
Re-expresses the single hunk `@@ -483,61 +483,59 @@ impl TypeRelation for NllTypeRelating` of fix.diff, which replaced
`if self.ambient_covariance() {..}` / `if self.ambient_contravariance() {..}` (each resetting ambient_variance
to Covariant/Contravariant) with `match self.ambient_variance {.. Invariant => both enter_forall directions ..}`.
I restored the old two-`if` form: in an invariant context both branches run with the variance reset to
covariant/contravariant, instead of relating bidirectionally in the invariant variance.
