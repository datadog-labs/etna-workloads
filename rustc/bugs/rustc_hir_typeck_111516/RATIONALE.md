# Adapted injection for Don't use can_eq in derive suggestion for missing method

Fix: https://github.com/rust-lang/rust/commit/c5604cd0b58f1f2c527ae76dac75a94c7dd23824

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn `consider_suggesting_derives_for_ty` (the 1.99.1 home of the old `can_derive` logic).

I re-added the `&& match trait_pred.trait_ref.args.as_slice() { [lhs, rhs] => can_eq(lhs, rhs), [_] => true, _ => false }` guard to `can_derive`.
This re-expresses the fix hunk `@@ -2090,20 +2090,6 @@ impl<'a, 'tcx> FnCtxt<'a, 'tcx>`, which removed `} && match trait_pred.trait_ref.substs.as_slice() { ... self.can_eq(self.param_env, lhs, rhs) ... }`.
Only the field name changed (`substs` is now `args`).
With the guard back, a derive suggestion is skipped when the trait's two type arguments don't unify, for example `PartialOrd<_>` on `A`.
