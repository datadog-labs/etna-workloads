# Adapted injection for Use an error struct instead of a panic

Fix: https://github.com/rust-lang/rust/commit/b780fa9219c4c921e3334971a9e673e22cbea375

# Rationale
File: compiler/rustc_codegen_llvm/src/llvm_util.rs, fn `push_cli_features`-style code under `// -Zfixed-x18` (flag-derived LLVM features).
Re-expresses hunk `@@ -618,11 +618,10 @@ global_llvm_features` of fix.diff: the fix replaced
`panic!("-Zfixed-x18 only allowed on aarch64")` with `sess.dcx().emit_fatal(FixedX18InvalidArch{..})` and moved the push into `else`.
Reintroduced the panic (and unconditional push). The errors.rs/messages.ftl additions (diagnostic struct, now in diagnostics.rs) were left in place; they are simply unused-by-this-path.
