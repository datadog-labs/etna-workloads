# Adapted injection for Avoid ICE in drop recursion check in case of invalid drop impls

Fix: https://github.com/rust-lang/rust/commit/ad511ef92ed5454182c1c6b3afe0846d654af009

# Hunk: compiler/rustc_mir_transform/src/check_call_recursion.rs, `CheckDropRecursion::run_lint`
The drop-recursion lint moved here from rustc_mir_build/src/lints.rs. I removed the guard
`// avoid erroneous Drop impls from causing ICEs below` and `&& sig.inputs().skip_binder().len() == 1`
(fix hunk `@@ -72,15 +72,14 @@ pub fn check_drop_recursion`). Without it, an erroneous `fn drop()` with no inputs reaches `sig.input(0)` and ICEs (index out of bounds).
The sty.rs `#[track_caller]` hunk is diagnostic only and was not reverted.
