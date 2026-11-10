# Adapted injection for Remove fake borrows of refs that are converted into non-refs in MakeByMoveBody

Fix: https://github.com/rust-lang/rust/commit/e54bde6d473941ff45643f494a902f23b19e7c9a

# Rationale
File: compiler/rustc_mir_transform/src/coroutine/by_move_body.rs, `impl MutVisitor for MakeByMoveBody`.
- Removed `visit_statement`, which turned `_x = &fake shallow (_1.N)` into Nop when the capture is remapped with peel_deref=true. Re-expresses fix hunk `@@ -312,10 +313,46 @@ impl<'tcx> MutVisitor<'tcx> for MakeByMoveBody<'tcx>` (added `fn visit_statement`... `statement.kind = mir::StatementKind::Nop;`).
- Removed `self.super_local_decl(local, local_decl);` from `visit_local_decl` (same hunk, added line).
The first two hunks (Some(...)/.flatten()) were refactoring support and are already present; unneeded for the bug.
