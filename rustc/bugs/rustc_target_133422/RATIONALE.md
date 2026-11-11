# Adapted injection for Fix clobber_abi in RV32E and RV64E inline assembly

Fix: https://github.com/rust-lang/rust/commit/736c397f41f9030e500199fc28b56a7fab703759

# Rationale
File compiler/rustc_target/src/asm/mod.rs, `InlineAsmClobberAbi::parse`, RiscV32/RiscV64 arm.
Re-expresses the fix hunk `@@ -968,7 +970,11 @@` which changed
`"C" | "system" | "efiapi" => Ok(InlineAsmClobberAbi::RiscV)` into
`Ok(if riscv::is_e(target_features) { RiscVE } else { RiscV })`.
Buggy behaviour restored: always return `RiscV`, so RV32E/RV64E clobber_abi("C") clobbers x16-x17, x28-x31 (registers that don't exist on E).
The other fix hunks (new parameter, RiscVE variant/regs, is_e helper) are plumbing that remain in 1.99.1; the RiscVE variant is now unused.
