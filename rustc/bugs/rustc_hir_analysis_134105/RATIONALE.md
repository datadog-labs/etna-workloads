# Adapted injection for Validate self in host predicates correctly

Fix: https://github.com/rust-lang/rust/commit/5d1b6bfc6ad95298fe3637857976945bd6ae9d9d

# Rationale
File: compiler/rustc_hir_analysis/src/collect/clauses_of.rs (was predicates_of.rs), fn assert_only_contains_predicates_from, `PredicateFilter::SelfOnly` arm.
Removed the `ty::ClauseKind::HostEffect(..) => assert_eq!(self_ty, ty)` arm and put `HostEffect(..)` back in the `bug!("unexpected non-`Self` predicate...")` list.
Re-expresses fix hunk `@@ -711,12 +711,19 @@` which added the HostEffect self_ty assert and removed `| ty::ClauseKind::HostEffect(..)` from the bug! list.
