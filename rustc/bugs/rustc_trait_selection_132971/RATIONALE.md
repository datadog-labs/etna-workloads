# Adapted injection for Handle infer vars in anon consts on stable

Fix: https://github.com/rust-lang/rust/commit/6dad0749075b77b08788f530dca5a3af0a26b6d7

# Rationale
File: compiler/rustc_trait_selection/src/traits/mod.rs, fn `try_evaluate_const`, match arm `AnonConstKind::RepeatExprCount`.

Re-expresses the hunk `@@ -578,16 +578,28 @@ pub fn try_evaluate_const` of fix.diff, which added
`else if tcx.def_kind(uv.def) == DefKind::AnonConst && uv.has_non_region_infer()` and then evaluated
with `GenericArgs::identity_for_item` and `tcx.param_env(uv.def)`.
In 1.99.1 that logic is the RepeatExprCount arm. I restored the pre-fix behaviour: when the alias const
has inference variables, it keeps the original args (`alias_const.args`) and the current param env
instead of switching to identity args. Evaluation then sees inference variables and ICEs.

The first hunk of the fix (`ConstKind::Expr` bug! in mir/consts.rs) is a diagnostic-only addition, not reverted.
