# Adapted injection for fix fn_sig ice

Fix: https://github.com/rust-lang/rust/commit/f6725c0a9833b48d3d8bc463385872b3a5227dad

# Rationale

Upstream fix: `check.rs` `check_body` changed `let return_ty = tcx.fn_sig(def_id).output();` to `self.ccx.fn_sig().output()`
(hunk `@@ -242,7 +242,7 @@ impl<'mir, 'tcx> Checker<'mir, 'tcx>`), because `tcx.fn_sig` ICEs on closures.
In 1.99.1 the const-fn return-type check in check_body no longer exists, and `ConstCx::fn_sig` (the other fix hunk) is already there but unused.

## Hunk 1: compiler/rustc_const_eval/src/check_consts/check.rs, `Checker::check_body`
Re-added the "check the return type of a const fn by its signature" block, using `tcx.fn_sig(def_id)` directly
(the pre-fix line) rather than `self.ccx.fn_sig()`. It runs for `ConstContext::ConstFn`, which includes const closures, so it ICEs on them.

## Hunk 2: compiler/rustc_const_eval/src/const_eval/fn_queries.rs, `constness`
Removed `return Constness::NotConst;` after the "cannot use `const` closures outside of const contexts" error.
Not in the fix; needed because in 1.99.1 that early return keeps the closure from being const-checked, so the hunk-1 path is unreachable for the oracle test
(in 2023 the closure was still const-checked after the error). It only restores that flow.
