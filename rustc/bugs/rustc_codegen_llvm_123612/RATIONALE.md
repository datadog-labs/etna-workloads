# Adapted injection for Set target-abi module flag for RISC-V targets

Fix: https://github.com/rust-lang/rust/commit/f19c48e7a83ad146f461adfdf1b4288eabbecbc8

# Rationale
File compiler/rustc_codegen_llvm/src/context.rs, fn llvm_module_flags/context setup (`create_module`): removed the block
"Emit RISC-V specific target-abi metadata" that calls `llvm::add_module_flag_str(llmod, Error, "target-abi", llvm_abiname)` for RiscV32/RiscV64.
Re-expresses the fix hunk in context.rs adding `+    // Emit RISC-V specific target-abi metadata ... LLVMRustAddModuleFlagString(... "target-abi" ...)`.
The rename hunks (LLVMRustAddModuleFlag -> ...U32) were pure refactors and were not reproduced (already renamed in 1.99.1).
