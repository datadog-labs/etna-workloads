# Adapted injection for CFI: Fix error compiling core with LLVM CFI enabled

Fix: https://github.com/rust-lang/rust/commit/f837c48f0d8da1a205b7ab97846bc90f8d497271

# Rationale
Only one hunk changed: compiler/rustc_session/src/session.rs, `validate_commandline_args_with_session_available`.
I removed the check "LLVM CFI using rustc LTO requires a single codegen unit" (emit SanitizerCfiRequiresSingleCodegenUnit when cfi && Lto::Fat && codegen_units != 1).
This re-expresses fix hunk `@@ -1616,13 +1616,19 @@ fn validate_commandline_args_with_session_available` which added:
`if sess.is_sanitizer_cfi_enabled() && sess.lto() == config::Lto::Fat && !(sess.codegen_units().as_usize() == 1) { sess.emit_err(errors::SanitizerCfiRequiresSingleCodegenUnit); }`
Without it, CFI+fat LTO with multiple CGUs is silently accepted (pre-fix behaviour). The other fix hunks (LLVM wrapper, LowerTypeTests, GV filtering) already differ/moved in 1.99.1 and were not touched.
