# Adapted injection for Stop bailing out from compilation just because there were incoherent traits

Fix: https://github.com/rust-lang/rust/commit/83738a9b1ce5e67687f04cf6ce3f8cc29cb92af7

Re-expressed the fix's added `coherent_trait` guards (removing them restores the pre-fix behaviour):
- compare_impl_item.rs `check_type_bounds`: removed `tcx.ensure_result().coherent_trait(impl_trait_ref.def_id)?;` (fix hunk `@@ -1990,6 +1990,10 @@ check_type_bounds`).
- wfcheck.rs `check_associated_item`: removed `coherent_trait(tcx.parent(item.trait_item_or_self()?))?` (hunk `@@ -1005,6 +1005,11 @@ fn check_associated_item`).
- wfcheck.rs `check_impl`: removed `coherent_trait(trait_ref...def_id)?` (hunk `@@ -1291,6 +1296,9 @@ fn check_impl`).
- hir_typeck/callee.rs `check_legal_trait_for_method_call`: tail `tcx.coherent_trait(trait_id)` replaced with `Ok(())` (hunk `@@ -51,8 +51,9 @@`, which added `tcx.coherent_trait(trait_id)`).
Other hunks (lib.rs, _impl.rs, confirm.rs) already differ in 1.99.1 and were not touched.
