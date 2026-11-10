# Adapted injection for Check static is sized when building MIR.

Fix: https://github.com/rust-lang/rust/commit/832207862a2e74ec51879b072fd0dd2599395b91

# Re-injection of #129109 / #130970 (fix 832207862a2, PR #144226)

## Bug
The parent of the fix built `ExprKind::StaticRef` into a single-scalar MIR constant
(`ConstValue::Scalar(ptr)`) no matter what type the static had. For an ill-formed, unsized
static (e.g. `extern { static mut symbol: [i8]; }`), `&raw mut symbol` is a wide pointer
(ScalarPair), so MIR got an inconsistent constant, and later passes (validate-mir, GVN,
const-prop) ICE'd on it. The fix had `as_constant_inner` check that the pointee is `Sized`
and emit an error constant if not. Because of that, it could drop the
`try_as_immediate` ABI-check helpers and use `as_mplace_or_imm().right()` in
known_panics_lint instead.

## Where that logic is in 1.99.1
Commit 7c6496145f8 ("Check statics' type in type_of", the same PR) reverted the
`as_constant.rs`/`instruction.rs` hunks and moved the guarantee into `type_of`: a static whose
type fails `check_static_item` (which includes the `Sized` obligation) gets type `{type error}`.
So in 1.99.1 `as_constant_inner` is already in its pre-fix form (StaticRef → always
`Const::Val(ConstValue::Scalar(..), ty)`), and the only thing stopping MIR from seeing a
static reference to an unsized type is the `Ty::new_error` in `type_of`. That is where the fix's
"static must be Sized before we make a scalar constant for it" now lives.

## Changed hunks

### 1. compiler/rustc_hir_analysis/src/collect/type_of.rs — `type_of`, `ForeignItemKind::Static` arm
Ignores the `Err` from `check_static_item` and returns the lowered (unsized) type instead of
`Ty::new_error`. The error is still reported, but MIR building now gets `StaticRef` with type
`*mut [i8]` and produces `const {alloc1: *mut [i8]}` as a single Scalar (checked with
`-Zdump-mir`). That is the ill-formed constant the fix was meant to prevent.
This re-expresses the fix's as_constant.rs hunk (whose 1.99.1 successor is this check):
```
@@ -88,8 +83,19 @@ pub(crate) fn as_constant_inner<'tcx>(
         ExprKind::StaticRef { alloc_id, ty, .. } => {
-            let const_val = ConstValue::Scalar(Scalar::from_pointer(alloc_id.into(), &tcx));
-            let const_ = Const::Val(const_val, ty);
+            let pointee = ty.builtin_deref(true).expect("StaticRef's type must be pointer");
+            let const_ = if pointee.is_sized(tcx, typing_env) {
 ...
+                let guar =
+                    tcx.dcx().span_delayed_bug(span, format!("static's type `{ty}` is not Sized"));
+                Const::Ty(ty, ty::Const::new_error(tcx, guar))
```
The supporting hunks `@@ -8,7 +8,7 @@` / `@@ -19,32 +19,27 @@` (as_constant.rs) and
`@@ -309,7 +309,7 @@` / `@@ -393,7 +393,7 @@` (instruction.rs) only threaded a `TypingEnv`
into `as_constant_inner`. They are already reverted in 1.99.1, so they needed no change.
(Only the foreign-static arm was changed, matching the oracle and issues #129109/#130970, both
of which are extern statics.)

### 2. compiler/rustc_const_eval/src/interpret/operand.rs — `ImmTy::try_from_immediate` restored
Reverse of fix hunk `@@ -243,17 +243,6 @@ impl<'tcx, Prov: Provenance> std::ops::Deref for ImmTy<'tcx, Prov>`
(`-    pub fn try_from_immediate(imm: Immediate<Prov>, layout: TyAndLayout<'tcx>) -> Option<Self> {`).
Only adaptation: `BackendRepr::ScalarPair` is now a struct variant, so the pattern is `ScalarPair { .. }`.

### 3. compiler/rustc_const_eval/src/interpret/place.rs — `OpTy::try_as_immediate` restored
Reverse of fix hunk `@@ -313,14 +313,6 @@ impl<'tcx, Prov: Provenance> Projectable<'tcx, Prov> for PlaceTy<'tcx, Prov>`
(`-    pub fn try_as_immediate(&self) -> Option<ImmTy<'tcx, Prov>> {`).

### 4. compiler/rustc_mir_transform/src/known_panics_lint.rs — `ConstPropagator::eval_constant`
Back to `...eval_mir_constant(&val, c.span, None))?.try_as_immediate()`, reversing
`@@ -263,7 +263,9 @@ impl<'mir, 'tcx> ConstPropagator<'mir, 'tcx>`
(`-        self.use_ecx(...)?.try_as_immediate()` / `+ .as_mplace_or_imm() + .right()`).
(Without hunks 2–4, a full compile with hunk 1 alone ICE'd in known_panics_lint at
operand.rs:279 "immediate Scalar(alloc1) does not fit to layout ... *mut [i8]". With them, the
compiler behaves as it did before the fix there.)
