# Adapted injection for support XCOFF in `naked_asm!`

Fix: https://github.com/rust-lang/rust/commit/f35bda3997d285618b267f1b25eebff2ff467387

All in compiler/rustc_codegen_ssa/src/mir/naked_asm.rs, fn prefix_and_suffix (1.99.1 code has diverged, so the align_bytes rename hunk is already present/irrelevant).
1. Weak linkage match (fix hunk `@@ -157,12 +158,16 @@`): restored `BinaryFormat::Elf | Coff | Wasm | Xcoff => writeln!(".weak ...")`, removing the Xcoff `emit_fatal` arm.
2. Section match (fix hunks `@@ -189,7 +194,7 @@` and `@@ -279,6 +284,33 @@`): `BinaryFormat::Elf | BinaryFormat::Xcoff =>` shares the ELF arm again (emits `.pushsection`/`.balign`/`.type`, which XCOFF can't assemble); the dedicated Xcoff arm (`.align N`, no section) was removed.
