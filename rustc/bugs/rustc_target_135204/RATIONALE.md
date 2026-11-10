# Adapted injection for fix ZST handling for Windows ABIs on MSVC target

Fix: https://github.com/rust-lang/rust/commit/d760bb66033c3b5688fbdd96119a31adc5f7441c

# Rationale
One hunk: `compiler/rustc_target/src/callconv/x86_win64.rs`, `compute_abi_info` (ZST arg loop).

Re-expresses the fix hunk `@@ -40,11 +44,15 @@ pub(crate) fn compute_abi_info<Ty>(...)` in x86_win64.rs, which replaced
`if arg.is_ignore() { if os == "windows" && env == "gnu" && arg.layout.is_zst() { make_indirect_from_ignore } }`
with a rule that makes ZST indirect for windows-gnu OR any non-`extern "C"` ABI.
In 1.99.1 the code already made all ignored ZSTs indirect (the abi param is gone), so the bug is restored by
making ZST indirect only on windows-gnu (parent behaviour); explicit win64/vectorcall ABIs on linux/msvc
then ignore ZSTs again.
