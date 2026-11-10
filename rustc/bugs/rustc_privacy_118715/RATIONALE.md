# Adapted injection for privacy: visit trait def id of projections

Fix: https://github.com/rust-lang/rust/commit/5d977240023003f9f8d82e42fd7d45bbfd630954

# Rationale
File `compiler/rustc_privacy/src/lib.rs`, `DefIdVisitorSkeleton::visit_ty`, `ty::Alias` arm.
Removed the branch `else if matches!(kind, ty::Projection { .. }) { self.visit_projection_term(data.into()) }`,
re-expressing the fix hunk `@@ -218,20 +218,21 @@` which added `} else if kind == ty::Projection { self.visit_projection_ty(data) }`.
Without it projections only visit their args, never the trait's DefId (the original bug, #117997).
