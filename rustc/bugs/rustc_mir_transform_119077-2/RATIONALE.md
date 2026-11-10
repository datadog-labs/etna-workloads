# Adapted injection for Lint missing StorageDead when returning from functions

Fix: https://github.com/rust-lang/rust/commit/1d36e3ae031b4a13bc27b142c13e6a590644031e

# Rationale
File: compiler/rustc_mir_transform/src/lint.rs, `Lint::visit_terminator`.
Removed the `TerminatorKind::Return` arm, which linted that no non-always-live local still has storage
(MaybeStorageLive) on return from a fn-like body ("still has storage when returning from function").
This re-expresses the fix hunk `@@ -74,4 +85,27 @@ impl<'a, 'tcx> Visitor<'tcx> for Lint` which added
`fn visit_terminator ... TerminatorKind::Return => { if self.is_fn_like && ... "local {local:?} still has storage when returning from function"`.
The `Call` arm (added later upstream) is kept. The `is_fn_like`/`always_live_locals` fields (hunks @@ -18,13 / @@ -74) are left, now unused (dead-code warning only).
