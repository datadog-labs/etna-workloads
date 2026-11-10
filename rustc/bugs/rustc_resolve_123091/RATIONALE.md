# Adapted injection for Delegation: fix ICE on wrong `self` resolution

Fix: https://github.com/rust-lang/rust/commit/17c6101864a3d7f5d655d69f18c7bd1cf8bfa92c

# Hunk: compiler/rustc_resolve/src/late.rs, `resolve_item` arm `ItemKind::Delegation`
Removed the `with_generic_param_rib(&[], RibKind::Item(HasGenericParams::Yes(span), def_kind), ...)` wrapper
around `resolve_delegation`, restoring the pre-fix `self.resolve_delegation(delegation, ...)` call.
Re-expresses fix hunk `@@ -2531,7 +2531,17 @@ ... ItemKind::Delegation(ref delegation)` which replaced
`self.resolve_delegation(delegation);` with the generic-param-rib wrapper. Without the rib, outer generic
params (e.g. `T` in `bar<T>`) are used inside the delegation body without the E0401 error.
The assoc-item hunks were left intact.
