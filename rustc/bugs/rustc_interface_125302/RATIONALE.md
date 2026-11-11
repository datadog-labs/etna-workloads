# Adapted injection for defrost RUST_MIN_STACK=ice rustc hello.rs

Fix: https://github.com/rust-lang/rust/commit/9985821b2fe20a969b799ec920563170fcc45d8f

# Rationale
File: compiler/rustc_interface/src/util.rs, fn `init_stack_size`.
Re-expresses fix hunk `@@ -51,20 +51,32 @@ ... fn init_stack_size(early_dcx: &EarlyDiagCtxt)`: the fix replaced
`.map(|s| s.trim().parse::<usize>().unwrap())` with `unwrap_or_else(|_| early_dcx.early_fatal(...))`.
I restored the `.unwrap()` (so invalid RUST_MIN_STACK panics/ICEs instead of a clean fatal error); the early_dcx parameter is now unused (`_early_dcx`).
The other hunks (threading early_dcx / thread_stack_size) already exist in 1.99.1 and are plumbing only.
