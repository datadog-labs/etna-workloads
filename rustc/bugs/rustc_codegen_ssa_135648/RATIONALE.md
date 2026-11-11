# Adapted injection for support wasm inline assembly in naked functions

Fix: https://github.com/rust-lang/rust/commit/8dec09f3c5bf8e1f12c6ba6eb6040d710353ca63

# Rationale
File: compiler/rustc_codegen_ssa/src/mir/naked_asm.rs, fn prefix_and_suffix (write_linkage closure).

Re-expresses fix hunk `@@ -169,7 +176,7 @@ fn prefix_and_suffix`:
`-  AsmBinaryFormat::Elf | AsmBinaryFormat::Coff => {` / `+  ... | AsmBinaryFormat::Wasm => { writeln!(w, ".weak {asm_name}")`.
Wasm is removed from the `.weak` arm and given its own arm that emits only `.globl`, so weak-linkage naked functions on wasm lose their `.weak` directive (weak_aligned_nop test).
The rest of the fix (Wasm format, .functype) is already present in 1.99.1 and left intact.
