# Adapted injection for Delegation: fix ICE on recursive delegation

Fix: https://github.com/rust-lang/rust/commit/6f78e6265a6b43ea53abf048efa688fa0cdb33d9

# Rationale
File: compiler/rustc_ast_lowering/src/delegation/resolution.rs, fn `check_for_cycles`.
The fix (hunk `@@ -67,7 +67,9 @@ impl<'hir> LoweringContext` in delegation.rs, replacing `delegation_fn_sigs[&local_sig_id].has_self` with `.get(..).map_or(false, ..)`) made recursive (self) delegation tolerated at that point, deferring the error. That code was rewritten in 1.99.1; the equivalent is the self-recursion check (visited.len()==1) in `check_for_cycles`. The bug is re-expressed by letting direct self-delegation pass the early check (`return Ok(())`) so later lowering proceeds with a recursive sig and no proper "recursive delegation" diagnostic is emitted.
