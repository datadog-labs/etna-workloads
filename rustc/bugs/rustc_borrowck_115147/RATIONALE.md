# Adapted injection for Suggest mutable borrow on read only for-loop that should be mutable

Fix: https://github.com/rust-lang/rust/commit/c1a7af0f2a691c2e74479156475018b497f3c288

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mutability_errors.rs, fn `suggest_similar_mut_method_for_for_loop`.
Removed the `AddrOf(BorrowKind::Ref, Mutability::Not, expr)` arm that emitted "use a mutable iterator instead" (`mut ` insertion), and the now-unused imports.
Re-expresses fix hunk `@@ -781,83 +778,88 @@ ... fn suggest_similar_mut_method_for_for_loop(&self, err: &mut Diagnostic, span: Span)`, which added the `AddrOf` match arm (`for _ in &i` -> `for _ in &mut i`). Before the fix, `for x in &v` gave no such suggestion.
