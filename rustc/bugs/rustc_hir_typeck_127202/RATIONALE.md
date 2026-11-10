# Adapted injection for Avoid an ICE reachable through const eval shenanigans

Fix: https://github.com/rust-lang/rust/commit/61963fabdf2eaf9a68be970dfad7eb470a0fc0d5

compiler/rustc_hir_typeck/src/method/confirm.rs, `unify_receivers` (non-arbitrary_self_types branch of the Err arm), plus `use tracing::{debug, error}` so `error!` resolves.
Re-expresses fix hunk `@@ -510,9 +510,12 @@ impl<'a, 'tcx> ConfirmContext`: removes `self.dcx().span_delayed_bug(...)` and restores
`error!("{self_ty} was a subtype of {method_self_ty} but now is not?"); self.dcx().has_errors().unwrap();`,
which panics when typeck runs (via const eval) before wfcheck has emitted an error.
