# Adapted injection for Make compare_impl_item into a query

Fix: https://github.com/rust-lang/rust/commit/a3623f20ae18996f31cc4a5a431d8afaa382247e

# Rationale
File: compiler/rustc_ty_utils/src/instance.rs, `resolve_associated_item`.
Re-expresses the fix hunk `@@ -216,15 +216,13 @@ fn resolve_associated_item`: the fix dropped
`leaf_def.item.kind == ty::AssocKind::Const &&` so that compare_impl_item runs for every impl item kind
(fns, types) when resolving an instance. I restored the Const-only condition
(`matches!(leaf_def.item.kind, ty::AssocKind::Const { .. })`), so a mismatched-signature fn impl is no longer checked
at resolution and const eval can ICE/misbehave (eval-bad-signature).
Other hunks (query rename, check.rs, compare_impl_item.rs) are already in the fixed shape in 1.99.1 and were left alone.
