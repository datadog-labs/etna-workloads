# Adapted injection for Fix ICE on type alias in recursion

Fix: https://github.com/rust-lang/rust/commit/21bcd2ee9c9e8d4453afc28a7f736ee754241457

# Hunk: compiler/rustc_query_impl/src/handle_cycle_error.rs, `find_item_ty_spans`
(values.rs moved here in 1.99.1.) Replaced the check `if let Res::Def(kind, def_id) = path.res && matches!(kind, Enum|Struct|Union)` with `if let Some(def_id) = path.res.opt_def_id()`.
This re-expresses the fix hunk `@@ fn find_item_ty_spans`: `-if let Some(def_id) = path.res.opt_def_id() {` / `+if let Res::Def(kind, def_id) = path.res && kind != DefKind::TyAlias {`.
Type aliases are again passed to `params_in_repr`, which ICEs for an extern-crate alias.
