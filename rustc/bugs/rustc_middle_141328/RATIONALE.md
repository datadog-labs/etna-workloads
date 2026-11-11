# Adapted injection for When AsyncDrop impl is empty, sync drop generated in elaborator (Fixes #140974)

Fix: https://github.com/rust-lang/rust/commit/dc794f18a425a20563943ea4201b34ebea2aa017

# Rationale
The fix guarded `tcx.associated_item_def_ids(drop_trait)[0]` in `build_async_drop` (`@@ -251,7 +251,29 @@`, "impl_item_refs may be empty ... `let Some(drop_fn_def_id) = ... .nth(0)` else span_delayed_bug + sync Drop terminator"). In 1.99.1 that code was rewritten: the elaborator indexes the trait's items and an impl with missing `drop` is rejected earlier by `calculate_async_dtor`'s validate step, so the guard was no longer needed. The bug is re-expressed in two hunks:

1. `compiler/rustc_mir_transform/src/elaborate_drop.rs`, `build_async_drop` (call_destructor_only branch): again indexes the first item of the AsyncDrop *impl* unguarded (`associated_item_def_ids(impl_did)[0]`), which is the removed unguarded `[0]` of the fix hunk; panics with index OOB for an empty impl.
2. `compiler/rustc_middle/src/ty/util.rs`, `calculate_async_dtor`: validation failure (`validate(..).is_err() => continue`) no longer rejects the impl, so an incomplete impl (E0046) still becomes the ADT's async destructor and reaches the elaborator (the situation of #140974 in the parent commit, where the incomplete impl reached elaboration).
