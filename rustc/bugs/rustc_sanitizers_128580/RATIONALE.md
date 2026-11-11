# Adapted injection for Use ParamEnv::reveal_all in CFI

Fix: https://github.com/rust-lang/rust/commit/b0beb64830b082c78ea5f0b3d69ef2fa880728c4

# Hunk: compiler/rustc_sanitizers/src/cfi/typeid/itanium_cxx_abi/mod.rs, typeid_for_instance
Fix hunk `@@ -112,11 +112,12 @@ pub fn typeid_for_instance` replaced `tcx.param_env(instance.def_id())` with `ParamEnv::reveal_all()`.
In 1.99.1 the equivalent is `TypingEnv::fully_monomorphized()`; I restored a user-facing env,
`TypingEnv::non_body_analysis(tcx, instance.def_id())`, so opaque types can't be revealed and normalization fails (ICE).
The added assert hunk was left untouched (it does not affect behaviour).
