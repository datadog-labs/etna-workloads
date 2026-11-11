# Adapted injection for codegen `#[naked]` functions using `global_asm!`

Fix: https://github.com/rust-lang/rust/commit/bd8f8e063195d17ed7ddfd0895b9f235a90ab8f8

# Rationale
Only the instruction-set handling of the fix was re-expressed; the full global_asm conversion was not reverted (too large and already reworked in 1.99.1).

File: compiler/rustc_codegen_ssa/src/mir/naked_asm.rs, fn `prefix_and_suffix`.
Re-expresses the fix's new-file hunk in naked_asm.rs (`let (arch_prefix, arch_suffix) = if is_arm { ... match attrs.instruction_set { None => ..., Some(InstructionSetAttr::ArmT32) => ".thumb\n.thumb_func", Some(InstructionSetAttr::ArmA32) => ".arm" }`).
Bug: the `#[instruction_set(arm::t32/a32)]` attribute on a naked fn is ignored; the module default (is_thumb) is always used.
