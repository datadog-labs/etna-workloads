# Adapted injection for Do not forget to pass DWARF fragment information to LLVM.

Fix: https://github.com/rust-lang/rust/commit/b3bbc22cb7b3670001389c07a1e4a1c2090ae76a

# Rationale
File compiler/rustc_codegen_ssa/src/mir/debuginfo.rs, fn `debug_introduce_local` (the `dbg_var_addr` calls near the end).
Both calls (spill branch and direct branch) now pass `&None` instead of `&var.fragment`, re-expressing both fix hunks
(`@@ -445,9 +445,23 @@`: `bx.dbg_var_addr(..., &[Size::ZERO], None)` -> `var.fragment`, and the else branch `..., &indirect_offsets, None)` -> `var.fragment`).
DWARF fragment info is thus not passed to LLVM for these variables.
