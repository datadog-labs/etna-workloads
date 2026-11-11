# Adapted injection for Emit error when self type is not specified and accessed

Fix: https://github.com/rust-lang/rust/commit/6bd5ab92bd0b407db7ba74d41bf49d900aa887cf

# Rationale
The fix's hunks (delegation.rs `get_delegation_self_ty_or_err` emitting `DelegationSelfTypeNotSpecified`, plus errors.rs struct) don't exist in 1.99.1: delegation was restructured. There, `get_delegation_self_ty` (rustc_hir_analysis/src/delegation.rs) falls back to an error type (`Ty::new_error_with_message`, no diagnostic emitted) when `self_ty_propagation_kind` is `None` — exactly the fix's `unwrap_or_else` branch (`@@ -284,6 +285,12 @@ fn get_delegation_self_ty_or_err`, which added `emit_err(DelegationSelfTypeNotSpecified)` there). Clean 1.99.1 never reaches it for free-to-trait reuse because lowering always supplies a kind.

Single hunk: compiler/rustc_ast_lowering/src/delegation/generics.rs, in the construction of `GenericsGenerationResults` (`self_ty_propagation_kind`): when `res.qself_is_none` (e.g. `reuse Default::default;`), produce `None` instead of `Some(SelfParam)`. The self type is then "not specified", the silent error-type fallback is hit, and no "self type not specified" error is emitted (the state before the fix, #156388).
