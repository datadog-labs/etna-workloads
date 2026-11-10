# Adapted injection for Check that impls of `#[type_const]` consts also have the attr

Fix: https://github.com/rust-lang/rust/commit/db2fbdb714fbb88ba9897947e6f8c66093a0214e

# Hunks
1. compiler/rustc_hir_analysis/src/check/compare_impl_item.rs, `compare_impl_const`: removed the call `compare_type_const(tcx, impl_const_item, trait_const_item)?;` (fix hunk `@@ -1984,12 +1985,46 @@ fn compare_impl_const` added that call). The function is kept with `#[allow(dead_code)]` so it builds warning-free. Impls of `#[type_const]` trait consts no longer need the attribute.
2. compiler/rustc_hir_analysis/src/collect.rs, `const_of_item`: restored `hir::ConstItemRhs::Body(body_id) => bug!("cannot call const_of_item on a non-type_const {body_id:?}")` instead of span_delayed_bug + error const (fix hunk `@@ -1600,8 +1600,12 @@ fn const_of_item`).
