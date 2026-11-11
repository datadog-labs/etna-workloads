# Adapted injection for Dont resolve instance of root in mir_callgraph_cyclic

Fix: https://github.com/rust-lang/rust/commit/a40274d6cc17725d990cf8f3a02d553b5e9100bf

Hunk: compiler/rustc_mir_transform/src/inline/cycle.rs, fn mir_callgraph_cyclic.
Fix hunk `@@ -155,15 +155,8 @@ pub(crate) fn mir_callgraph_cyclic`: replaced
`let Ok(Some(root_instance)) = ty::Instance::try_resolve(...) else { return involved.into() }` with
`ty::Instance::new_raw(root.to_def_id(), identity_for_item)`.
Reintroduced the try_resolve (bailing with `Some(involved.into())`, matching 1.99.1's Option return type), so a default trait body root that cannot be resolved skips inlining analysis.
