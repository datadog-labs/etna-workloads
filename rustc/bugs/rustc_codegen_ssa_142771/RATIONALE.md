# Adapted injection for codegen: Generate `dbg_value` for the ref statement

Fix: https://github.com/rust-lang/rust/commit/1bd89bd42e0bb6f29b8af5d6bdf3f756196bb8ee

# Rationale
The fix added emission of `dbg_value` for ref statements by calling `codegen_stmt_debuginfos` at two sites. On 1.99.1 the machinery exists (mir/debuginfo.rs), so the bug is re-injected by removing the calls.

- compiler/rustc_codegen_ssa/src/mir/statement.rs, `codegen_statement`: removed `self.codegen_stmt_debuginfos(bx, &statement.debuginfos);`. Re-expresses fix hunk `@@ -1,13 +1,17 @@ ... pub(crate) fn codegen_statement` which added that line.
- compiler/rustc_codegen_ssa/src/mir/block.rs, block codegen loop: removed `self.codegen_stmt_debuginfos(bx, &data.after_last_stmt_debuginfos);`. Re-expresses fix hunk `@@ -1320,6 +1320,7 @@` in block.rs.
