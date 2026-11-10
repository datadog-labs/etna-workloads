# Adapted injection for Normalize trait ref before orphan check & consider ty params in alias types to be uncovered

Fix: https://github.com/rust-lang/rust/commit/951e902562de6f052fe8ca77fbc733a752514a90

# Rationale
Only hunk: `compiler/rustc_next_trait_solver/src/coherence.rs`, `OrphanChecker::visit_ty`, the `ty::Alias` arm
(1.99.1 moved the orphan checker here from rustc_trait_selection/src/traits/coherence.rs).
Re-expresses fix hunk `@@ -889,19 +909,46 @@` of coherence.rs, which replaced
`| ty::Alias(ty::Projection | ty::Inherent | ty::Weak, ..) => self.found_non_local_ty(ty)` (old behaviour: params inside
alias types count as covered / alias is just non-local) with the new logic that calls `found_uncovered_ty_param(ty)`
for aliases containing infer/placeholder/bound vars (Compat mode alone keeps Projection covered).
Now in Local mode, Projection/Inherent/Free aliases with such vars call `found_non_local_ty` again, so uncovered
type params inside aliases are no longer reported.
