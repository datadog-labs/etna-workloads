# Adapted injection for Fix ICE: can't type-check body of DefId, since type_consts don't have a body.

Fix: https://github.com/rust-lang/rust/commit/f982bc6a2dd661dd5713a39e96d469c6309f3b2e

# Rationale
File: compiler/rustc_mir_build/src/builder/expr/as_constant.rs, fn as_constant_inner, arm `ExprKind::NamedConst`.
Removed the early-return branch `if tcx.is_type_const(def_id) { ... Const::Ty(ty, ct) ... }` (in 1.99.1 it builds `ty::AliasConst`/`Const::new_alias`).
Re-expresses fix hunk `@@ -69,6 +70,13 @@ as_constant_inner` which added
`if tcx.is_type_const(def_id) { let uneval = ty::UnevaluatedConst::new(def_id, args); ... return ConstOperand {..} }`.
Without it, a type_const named const used in a body becomes a `mir::UnevaluatedConst` and MIR const handling looks for a body that type_consts lack (the pre-fix ICE).
Other fix hunks (is_type_const centralization, infer_placeholder_type) are already refactored in 1.99.1 and were left alone.
