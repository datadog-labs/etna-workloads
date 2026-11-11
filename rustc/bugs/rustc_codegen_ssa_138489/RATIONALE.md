# Adapted injection for Describe lifetime of call argument temporaries passed indirectly

Fix: https://github.com/rust-lang/rust/commit/3b7ca287a7ecb80185f2c679e663cd9c94cdc9f4

# Rationale
File compiler/rustc_codegen_ssa/src/mir/block.rs, fn codegen_argument (the Rust-ABI argument passing in `PassMode::Pair` Immediate/Pair case and `Ref` + `PassMode::Indirect` case).
Removed the `bx.lifetime_start(scratch.llval, arg.layout.size);` and `lifetime_ends_after_call.push((scratch.llval, arg.layout.size));` lines in both places.
Re-expresses fix hunks `@@ -1517,7 +1534,9 @@` and `@@ -1538,7 +1557,9 @@` which added exactly these two lines each. Without them, indirectly passed argument temporaries (pair immediates, misaligned/by-ref copies) get no lifetime markers (issue #132014).
The rest of the plumbing (the Vec parameter) is left in place; it still serves the const-operand case.
