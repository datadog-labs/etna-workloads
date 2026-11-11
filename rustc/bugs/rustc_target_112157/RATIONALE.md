# Adapted injection for aarch64-linux: properly handle 128bit aligned aggregates

Fix: https://github.com/rust-lang/rust/commit/d1e764cb3bc961a4395164a36c4e0cfd57e681a1

# Rationale
File: compiler/rustc_target/src/callconv/aarch64.rs, `classify_arg` (moved from compiler/rustc_target/src/abi/call/aarch64.rs).
Re-expresses hunk `@@ -87,27 +81,39 @@ where` of fix.diff: the fix replaced
`let bits = size.bits(); if bits <= 128 { arg.cast_to(Uniform{unit: Reg::i64(), ..}) }`
with an `align` computed (unadjusted_abi_align on AAPCS, else align.abi) and `Reg::i128()` when align is 128 bits.
I removed the align computation and the i128 branch, so small aggregates always pass as i64 units (the buggy pre-fix behaviour: 128-bit-aligned aggregates passed as [2 x i64]).
The other fix hunks (unadjusted_abi_align field plumbing in layout code) are unused without this and not reverted.
