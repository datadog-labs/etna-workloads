# Adapted injection for Enforce tail call type is related to body return type in borrowck

Fix: https://github.com/rust-lang/rust/commit/c7ea022166d2b6d55c3f69bbf69a31b0d7b053e2

# Rationale
File: compiler/rustc_borrowck/src/type_check/mod.rs, `check_terminator` (Call | TailCall arm).
Fix hunk `@@ -845,9 +845,13 @@` replaced `if let TerminatorKind::Call { destination, target, .. } = term.kind { self.check_call_dest(...) }` with an unconditional call that, for TailCall, uses RETURN_PLACE as destination. In 1.99.1 the destination is already computed for TailCall, so I re-express the old behaviour by wrapping `check_call_dest` in `if let TerminatorKind::Call { .. } = term.kind`. Tail calls thus no longer relate the callee's return type to the body return type.
