# Adapted injection for x86_win64 ABI: do not use xmm0 with softfloat ABI

Fix: https://github.com/rust-lang/rust/commit/73b6482ead710656c14fbb86011aa0e7d65461fd

# Rationale
File: compiler/rustc_target/src/callconv/x86_win64.rs, fn compute_abi_info.
Re-expresses the fix hunk `@@ -24,10 +24,14 @@` (`if cx.target_spec().rustc_abi == Some(RustcAbi::X86Softfloat) { /* adjust nothing */ } else { cast_to(xmm0 vector) }`):
removed the softfloat branch so an i128 return is always cast to a 128-bit vector (xmm0), even on softfloat targets (e.g. x86_64-unknown-uefi).
Also removed the now-unused `RustcAbi` import (fix hunk `@@ -1,11 +1,11 @@`; `cx` stays used elsewhere in 1.99.1).
