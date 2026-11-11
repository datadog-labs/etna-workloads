# Adapted injection for find the generic container rather than simply looking up for the assoc with const arg

Fix: https://github.com/rust-lang/rust/commit/6026a0f6c988ce24194d8e525094386137326d50

# Rationale
File: compiler/rustc_hir_analysis/src/collect/type_of.rs, fn `const_arg_anon_type_of`.
In 1.99.1 the `Node::Ty(.. QPath::TypeRelative ..)` arm no longer existed, so the fix hunk
`@@ -175,19 +175,13 @@ fn const_arg_anon_type_of` could not be reversed. I re-added that arm (adapted to the
current Alias API), using the buggy lookup the fix removed:
`tcx.hir_parent_owner_iter(arg_hir_id).find(|(_, node)| matches!(node, OwnerNode::Item(_))).unwrap().0.def_id`
instead of the fixed `tcx.hir().get_parent_item(ty.hir_id).def_id`.
The ItemCtxt is then the enclosing trait item, not the fn, so `T` (a fn generic param) is not in scope
and lowering ICEs (query stack: type_param_clauses for `T`).
