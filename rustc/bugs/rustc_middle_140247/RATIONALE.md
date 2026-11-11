# Adapted injection for Don't build `ParamEnv` and do trait solving in `ItemCtxt`s

Fix: https://github.com/rust-lang/rust/commit/442862bc78b24f6019e4f3e32cfe2380dd480f26

# Hunk: compiler/rustc_middle/src/ty/inhabitedness/mod.rs, Ty::inhabited_predicate
Re-expresses fix hunk `@@ -127,7 +127,9 @@ impl<'tcx> Ty<'tcx>` (and the following `-139,12 +141,6` hunk): the fix merged
`Alias(ty::Inherent | ...)` into the `GenericType` arm and removed
`Alias(ty::Inherent, _) => bug!("unimplemented: inhabitedness checking for inherent projections")`.
I removed `Inherent` from the GenericType arm and restored the bug!() arm (adapted to 1.99.1 AliasTy kind syntax).
Only this hunk is re-injected (the rest of the fix is a large refactor that no longer applies cleanly).
