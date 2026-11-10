# Adapted injection for Enforce must_use on associated types and RPITITs

Fix: https://github.com/rust-lang/rust/commit/d1009a42d820ded1d446c62d3acb69dffc5117c8

# Rationale
File: compiler/rustc_lint/src/unused/must_use.rs (the code moved here from unused.rs), function is_ty_must_use, the `ty::Alias(_, AliasTy { kind: ... })` match arm.
Fix hunk `@@ -291,7 +291,7 @@ impl<'tcx> LateLintPass<'tcx> for UnusedResults`:
`-ty::Alias(ty::Opaque, ..)` / `+ty::Alias(ty::Opaque | ty::Projection, ..)`.
I reverted it by removing `ty::Projection { def_id }` from the arm's kind pattern. Only opaque types are elaborated for must_use bounds, so associated-type projections are no longer checked.
