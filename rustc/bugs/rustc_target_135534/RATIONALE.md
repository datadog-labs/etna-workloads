# Adapted injection for use indirect return for `i128` and `f128` on wasm32

Fix: https://github.com/rust-lang/rust/commit/702134a9300dd36b8c49a044a06d4bc8e454cf87

# Rationale
File: compiler/rustc_target/src/callconv/wasm.rs, fn `classify_ret`.
Fix hunk `@@ -27,6 +29,16 @@ ... classify_ret`: added the block
`// long double, __int128_t and __uint128_t use an indirect return` matching `BackendRepr::Scalar` with
`Primitive::Int(Integer::I128, _) | Primitive::Float(Float::F128)` -> `ret.make_indirect()`.
Re-injected bug: removed that block (so i128/f128 are returned directly on wasm32).
Also dropped the now-unused imports (fix hunk `@@ -1,3 +1,5 @@`, `use rustc_abi::{BackendRepr, Float, Integer, Primitive};`).
