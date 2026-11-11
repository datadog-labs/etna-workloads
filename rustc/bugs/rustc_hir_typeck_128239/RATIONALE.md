# Adapted injection for Don't ICE when encountering error regions when confirming object method candidate

Fix: https://github.com/rust-lang/rust/commit/8d2c12e5540d801a48eae396eac6aa350ce8c1b1

# Rationale
File: compiler/rustc_hir_typeck/src/method/confirm.rs, fn `fresh_receiver_args`, arm `probe::ObjectPick`.
Removed the early return `if self_ty.references_error() { return ty::GenericArgs::extend_with_error(self.tcx, trait_def_id, &[]); }`
(with its comment). This re-expresses fix hunk `@@ -268,6 +269,17 @@ impl<'a, 'tcx> ConfirmContext` which added that check.
Without it, error regions make extract_existential_trait_ref fail to deref the object type and ICE.
The import hunk (TypeVisitableExt) is not needed (the trait is presumably still imported/used elsewhere).
