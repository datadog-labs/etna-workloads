# Adapted injection for Do not inherit `ConstArgHasType` predicates when it is applied to const from delegation parent

Fix: https://github.com/rust-lang/rust/commit/4d1093d2d22cf5642a2a8abb84a7e5285327aaaf

# Rationale
File compiler/rustc_hir_analysis/src/delegation.rs, in the clause-inheriting method of the predicates builder (`inherit_predicates_for_delegation_item`).
I removed the block that skips `ConstArgHasType` clauses whose const maps to a delegation-parent const param. It corresponds to fix hunk `@@ -434,6 +437,44 @@ pub(crate) fn inherit_predicates_for_delegation_item` (the `if let ty::PredicateKind::Clause(ty::ClauseKind::ConstArgHasType(ct, _)) = ... && self.folder.delegation_parent_consts.contains(&param) { continue; }`).
So `ConstArgHasType(N, bool)` is inherited again alongside `(N, usize)`, giving the bug in #158675. The plumbing hunks (`delegation_parent_consts` field, `create_generic_args` return tuple) are left in place; they are now only unused data.
