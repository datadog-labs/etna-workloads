# Adapted injection for Preserve `___asan_globals_registered` symbol during LTO.

Fix: https://github.com/rust-lang/rust/commit/e6dddbda35399c08c7940477c363002ab1d276da

# Rationale
File: compiler/rustc_codegen_llvm/src/back/lto.rs, fn `prepare_lto`.
Removed `symbols_below_threshold.push(c"___asan_globals_registered".to_owned());` (and its comment).
In 1.99.1 the fix's logic moved from the C++ `LLVMRustRunRestrictionPass` lambda (fix hunk
`@@ -1058,6 +1058,13 @@ extern "C" void LLVMRustRunRestrictionPass`, which added
`if (GV.getName() == "___asan_globals_registered") return true;`) to the Rust-side list of preserved symbols.
Removing it makes fat LTO internalize `___asan_globals_registered` again (the original bug).
