# Adapted injection for unconditionally allow shadow call-stack for AArch64 whenever fixed-x18 is applied

Fix: https://github.com/rust-lang/rust/commit/b368dcb246c5aedb087034e0f62941d038799f38

# Hunk: compiler/rustc_session/src/session.rs, validate_commandline_args_with_session_available
Fix hunk `@@ -1187,7 +1187,12 @@ fn validate_commandline_args_with_session_available`: added
`let mut unsupported_sanitizers = ...` and `if fixed_x18 && arch == aarch64 { unsupported_sanitizers -= SHADOWCALLSTACK }`.
Reverted: restored the immutable `let unsupported_sanitizers = sanitizer - supported_sanitizers;` without the fixed-x18 exemption.
