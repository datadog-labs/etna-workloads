# Adapted injection for Impls and impl items inherit lint levels of the corresponding traits and trait items

Fix: https://github.com/rust-lang/rust/commit/12474ce192941fae1f354d85eadb32e9d1da25da

In compiler/rustc_passes/src/dead.rs, fn maybe_record_as_seed (code now uses push_into_worklist(WorkItem{..}) instead of worklist.push):
1. DefKind::AssocFn/AssocConst/AssocTy arm, `Impl { of_trait: true }` branch: removed the block that, if the trait item is local and allow/expect(dead_code), seeds the impl item. Re-expresses hunk `@@ -778,6 +778,15 @@ fn maybe_record_as_seed` (`trait_item_def_id()` ... `worklist.push((owner_id.def_id, comes_from_allow))`).
2. DefKind::Impl { of_trait: true } arm: removed the block that seeds the impl when its local trait is allow/expect(dead_code). Re-expresses hunk `@@ -791,6 +800,14 @@` (`impl_trait_ref(...).def_id.as_local()` ... `worklist.push(...)`).
