# Adapted injection for escape symbol names in global asm

Fix: https://github.com/rust-lang/rust/commit/b5d9b7f6837e50d8984275f11704d8c7f8493923

In compiler/rustc_codegen_llvm/src/asm.rs, `codegen_global_asm` (placeholder handling): the two call sites
(ConstScalar::Ptr, used for sym fn/static incl. naked_asm, and SymThreadLocalStatic) now push the raw mangled
symbol instead of `escape_symbol_name(self.tcx, &symbol, span)`. This re-expresses fix hunks
`@@ -414,7 +414,7 @@` and `@@ -428,7 +428,7 @@` (`-template_str.push_str(&symbol);` / `+...escape_symbol_name(...)`).
The helper itself already lives in rustc_codegen_ssa (moved since the fix), so the 3rd/4th hunks (adding the helper) are left alone; it is just unused by LLVM.
