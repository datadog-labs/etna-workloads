# Adapted injection for Lint node for PRIVATE_BOUNDS is the item which has the bounds

Fix: https://github.com/rust-lang/rust/commit/14e59bb317c3c901bce83deb16ee9bfa5cc90e28

compiler/rustc_privacy/src/lib.rs, SearchInterfaceForPrivateItemsVisitor::check_def_id:
the PRIVATE_BOUNDS/PRIVATE_INTERFACES lint is emitted on the HirId of `local_def_id` (the
private item named in the bound) instead of `self.item_def_id` (the item owning the bounds).
Re-expresses fix hunk `@@ -1504,7 +1505,7 @@` (`hir_id,` -> `local_def_id_to_hir_id(self.item_def_id)`).
So `#[allow(private_bounds)]` on the item with the bounds is not honored.
The first hunk (parent_module_from_def_id) was a pure refactor, not re-injected.
