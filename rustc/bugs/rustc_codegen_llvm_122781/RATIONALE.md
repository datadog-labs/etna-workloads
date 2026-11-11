# Adapted injection for Fix argument ABI for overaligned structs on ppc64le

Fix: https://github.com/rust-lang/rust/commit/009280c5e312bdf11cd0e0e1b336bf374eed7b00

One hunk: compiler/rustc_codegen_llvm/src/abi.rs, `impl LlvmType for CastTarget::llvm_type`.
Re-expresses fix hunk `@@ -150,... @@` in abi.rs: `if rest_count == 1 && !self.rest.force_array {`.
In 1.99.1 `force_array` became `is_consecutive` plus an i128 check. The condition was
`rest_count == 1 && (!self.rest.is_consecutive || self.rest.unit != Reg::i128())`.
I restored the old `rest_count == 1`, so `[1 x i128]` collapses to a bare `i128`, which is the bug
(wrong ABI for 16-byte, align-16 structs on ppc64le).
