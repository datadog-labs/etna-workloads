# Adapted injection for `#[optimize(none)]` implies `#[inline(never)]`

Fix: https://github.com/rust-lang/rust/commit/2c35bd0499130af395bdbb49a49d5a019599d22e

compiler/rustc_mir_transform/src/inline.rs, `check_codegen_attributes`: removed
`if let OptimizeAttr::DoNotOptimize = callee_attrs.optimize { return Err("has DoNotOptimize attribute"); }`
and the now-unused `OptimizeAttr` import. Re-expresses fix hunk `@@ -770,6 +770,10 @@ fn check_codegen_attributes` (and the import hunk @@ -4,7 +4,7 @@), so #[optimize(none)] callees can be MIR-inlined.
