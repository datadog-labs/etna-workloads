# Adapted injection for only query `params_in_repr` if def kind is adt

Fix: https://github.com/rust-lang/rust/commit/e9b2d09ad7905c51e7795730147f8d2303fb4bbd

compiler/rustc_query_impl/src/handle_cycle_error.rs, find_item_ty_spans (moved from rustc_middle/src/values.rs).
Re-expresses hunk `@@ -358,7 +358,7 @@ fn find_item_ty_spans(`: fix changed `!matches!(kind, DefKind::TyAlias)` to
`matches!(kind, DefKind::Enum | DefKind::Struct | DefKind::Union)`. I restored the `!matches!(kind, DefKind::TyAlias)` form, so params_in_repr is queried for non-ADT defs (e.g. assoc types).
