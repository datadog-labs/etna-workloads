# Adapted injection for Generate more verbose error delegation

Fix: https://github.com/rust-lang/rust/commit/eacf5b85561628a24bcda3e8c277c7cfbb686cbe

# Rationale
All in compiler/rustc_ast_lowering/src/delegation/mod.rs (file moved from delegation.rs in 1.99.1).

- `lower_delegation`: resolution failure now keeps the `ErrorGuaranteed` and calls `generate_delegation_error(err, span, delegation)`.
  Re-expresses hunks `-Err(err) => self.generate_delegation_error(err, span, delegation)` / `+Err(_) => ...(span, delegation)` (@@ -172,7) (reversed).
- `generate_delegation_error`: re-added the `err: ErrorGuaranteed` param (hunk @@ -604,7 +602,6, reversed).
- Body of `generate_delegation_error`: reverted to the old behaviour: no body -> `ExprKind::Err(err)`; body -> block with the target expr as a `Semi` stmt; no longer lowers the path / builds a `Call` (hunk @@ -622,36 +619,35, reversed). The unlowered path ICE (#154820) returns.
