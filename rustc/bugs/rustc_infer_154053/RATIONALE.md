# Adapted injection for Properly generalize unevaluated consts

Fix: https://github.com/rust-lang/rust/commit/75eeece98c6fc71bd076f3dad2d6808b15ea95f3

# Re-injection of the bug fixed by 75eeece98c6 ("Properly generalize unevaluated consts")

All changes are in `compiler/rustc_infer/src/infer/relate/generalize.rs`, `impl Generalizer`.
(Full diff: `inject.diff`.)

Bug: before the fix, the generalizer always related unevaluated (now: non-rigid alias) consts
*structurally*: it walked their args invariantly and never replaced the alias with a fresh
inference variable. The alias-replacement machinery (`generalize_alias_ty` /
`next_ty_var_for_alias`) handled only type aliases (`AliasTy`). The fix generalized that machinery
to `AliasTerm` so it covers consts as well, and routed `ConstKind::Unevaluated` through it.

In 1.99.1, the infrastructure parts of the fix are already present and still needed: `instantiate_var`,
`union_var_term`, the term-based `generalize`, `ct_vid`, and `ConstVariableValue::is_unknown`. Only
the parts that control how alias consts are generalized were reverted.

## Hunk A: `Generalizer::consts`, the `ty::ConstKind::Alias(ty::IsRigid::No, alias_const)` arm
Now always structural: it relates `args` invariantly and rebuilds `Const::new_alias(.., IsRigid::No, ..)`.
The `generalize_alias_term(alias_const.into())` path (taken under the next solver or without GCE)
is removed. This restores the parent commit's behaviour.

This re-expresses fix hunk `@@ -695,17 +748,26 @@ impl<'tcx> TypeRelation<TyCtxt<'tcx>> for Generalizer<'_, 'tcx> {`:
```
-            ty::ConstKind::Unevaluated(ty::UnevaluatedConst { def, args }) => {
-                let args = self.relate_with_variance(ty::Invariant, ..., args, args)?;
-                Ok(ty::Const::new_unevaluated(self.cx(), ty::UnevaluatedConst { def, args }))
-            }
+            ty::ConstKind::Unevaluated(uv) => match self.structurally_relate_aliases {
+                StructurallyRelateAliases::No if !self.cx().features().generic_const_exprs() => {
+                    self.generalize_alias_term(uv.into()).map(|v| v.expect_const())
+                }
+                _ => { ...structural... }
```
(`ConstKind::Unevaluated` is now `ConstKind::Alias(IsRigid::No, _)` in 1.99.1.)

## Hunk B: `next_var_for_alias_of_kind` reverted to `next_ty_var_for_alias(&self) -> Ty<'tcx>`
Re-expresses fix hunk `@@ -377,8 +424,12 @@ impl<'tcx> Generalizer<'_, 'tcx> {`:
```
-    fn next_ty_var_for_alias(&self) -> Ty<'tcx> {
-        self.infcx.next_ty_var_in_universe(self.span, self.for_universe)
+    fn next_var_for_alias_of_kind(&self, alias: ty::AliasTerm<'tcx>) -> ty::Term<'tcx> {
+        if alias.kind(self.cx()).is_type() { ...ty var... } else { ...const var... }
```

## Hunk C: `generalize_alias_term(AliasTerm) -> Term` reverted to `generalize_alias_ty(AliasTy) -> Ty`
Its body now uses `next_ty_var_for_alias()` and `alias.to_ty(..)`.
Re-expresses fix hunks `@@ -399,10 +450,10 @@` (`-fn generalize_alias_ty(... alias: ty::AliasTy<'tcx>) -> Result<Ty<'tcx>, ..>`
`+fn generalize_alias_term(... alias: ty::AliasTerm<'tcx>) -> Result<Term<'tcx>, ..>`), `@@ -410,12 +461,12 @@`
(`-return Ok(self.next_ty_var_for_alias());`, `-Ok(alias) => Ok(alias.to_ty(self.cx())),`) and `@@ -430,7 +481,7 @@`
(`-Ok(self.next_ty_var_for_alias())`).
One visible side effect, which the fix's test `.stderr` changes also record: the
`warn!("may incompletely handle alias type: {alias:?}")` message prints the `AliasTy` debug form again
instead of the `AliasTerm` form.

## Hunk D: `Generalizer::tys`, the `ty::Alias(ty::IsRigid::No, data)` arm
Now calls `self.generalize_alias_ty(data)` directly.
Re-expresses fix hunk `@@ -585,7 +636,9 @@`:
```
-                StructurallyRelateAliases::No => self.generalize_alias_ty(data),
+                StructurallyRelateAliases::No => {
+                    self.generalize_alias_term(data.into()).map(|v| v.expect_type())
```

## Why the `*` tests still pass
In 1.99.1, `rustc_type_ir::relate::combine::super_combine_consts` intercepts
`ConstKind::Alias(IsRigid::No, _)` under the next solver and emits a `ProjectionPredicate` *before*
it reaches `instantiate_const_var`/generalization. (This logic was added after the fix.) So in
`free-const-recursive.rs` and `projection-const-recursive.rs` the top-level `A == ?x` never reaches the
generalizer. Their expected output in 1.99.1 is already an E0275 overflow, and the injected compiler
reproduces it either way. The bug now shows up only for alias consts nested inside generalized terms.
The `AliasTy`/`AliasTerm` debug-output change, which is part of the same fix, makes the four non-`*` oracle cases fail.
