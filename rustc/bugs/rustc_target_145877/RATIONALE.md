# Adapted injection for Use captures(address) instead of captures(none) for indirect args

Fix: https://github.com/rust-lang/rust/commit/c3ab409b4fa3b1fb18f34877d9811bb502ed507f

# Hunk: compiler/rustc_target/src/callconv/mod.rs, `ArgAbi::indirect_pass_mode`
Indirect args get `ArgAttribute::CapturesNone` (captures(none)) again instead of `CapturesAddress`, and the old comment is restored.
Re-expresses fix hunk `@@ -400,11 +400,11 @@ impl<'a, Ty> ArgAbi<'a, Ty>`: `-.set(ArgAttribute::NoCapture)` / `+.set(ArgAttribute::CapturesAddress)`.
The other fix hunks (enum renames, LLVM wrapper) are already in 1.99.1 as CapturesNone/CapturesAddress variants, so only this selection needed reverting.
