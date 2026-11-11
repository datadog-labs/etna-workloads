# Adapted injection for Fix target_feature handling in freg of LoongArch inline assembly

Fix: https://github.com/rust-lang/rust/commit/0c8e36bb3052b217aebcd8bd2154cc31618caf4f

# Hunk: compiler/rustc_target/src/asm/loongarch.rs, LoongArchInlineAsmRegClass::supported_types
Fix hunk `@@ -38,7 +38,7 @@ impl LoongArchInlineAsmRegClass`: `Self::freg => types! { _: F32, F64; }` -> `types! { f: F32; d: F64; }`.
In 1.99.1 the line is `(Self::freg, _) => types! { f: F16, F32; d: F64; }`; I reverted it to `types! { _: F16, F32, F64; }`, so freg types no longer require the `f`/`d` target features (the buggy behaviour). F16 stays in the same group as F32 because it was already there.
