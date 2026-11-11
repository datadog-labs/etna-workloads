# Adapted injection for More assertions, tests, and miri coverage

Fix: https://github.com/rust-lang/rust/commit/d98b99af56e1260f520102a93f198ffe47793722

# Re-injection
Only file changed: compiler/rustc_trait_selection/src/traits/vtable.rs

- `first_method_vtable_slot` and `supertrait_vtable_slot`: the fix's hunks
  `@@ -323,11 +331,9 @@` and `@@ -384,11 +396,9 @@` replaced `trait_refs_are_compatible(tcx, erase_self_ty(vtable_principal), target_principal)`
  with plain `==`. I restored the `trait_refs_are_compatible(...)` calls.
- Restored `fn trait_refs_are_compatible` (fix hunk `@@ -408,27 +418,6 @@`, which deleted it) and its imports
  (`TyCtxtInferExt`, `ObligationCause`, `ObligationCtxt`; hunks `@@ -2,8 +2,6 @@` and `@@ -14,7 +12,7 @@`),
  adapted to current APIs (`Unnormalized::new_wip`, `evaluate_obligations_error_on_ambiguity().has_errors()`).
  Normalizing and unifying modulo binders picks the wrong vtable slot.

Not re-expressed: the added debug_asserts and the miri/interpreter refactors. They only add checks and do not introduce the bug.
