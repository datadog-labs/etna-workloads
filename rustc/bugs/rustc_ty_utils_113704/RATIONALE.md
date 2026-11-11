# Adapted injection for Implement assumed_wf_types for RPITITs' implementations

Fix: https://github.com/rust-lang/rust/commit/50d21091ee39319b4819b2c7e8ea6e8e78c75fb9

# Rationale
compiler/rustc_ty_utils/src/implied_bounds.rs, `assumed_wf_types`, `ImplTraitInTraitData::Impl { .. }` arm.
Re-expresses the fix hunk `@@ -44,41 +48,62 @@ fn assumed_wf_types` which added the
`ty::ImplTraitInTraitData::Impl { .. } => { ... tcx.assumed_wf_types_for_rpitit(rpitit_def_id) ... chain(tcx.assumed_wf_types(impl_def_id)) }` arm.
Before the fix, impl RPITITs fell to `DefKind::AssocTy => tcx.assumed_wf_types(tcx.local_parent(def_id))`, so the
trait's implied bounds were not inherited. The arm now does just that. The query/metadata plumbing hunks are left in place (unused, harmless).
