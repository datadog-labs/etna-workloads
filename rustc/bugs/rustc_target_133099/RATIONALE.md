# Adapted injection for forbid toggling x87 and fpregs on hard-float targets

Fix: https://github.com/rust-lang/rust/commit/d6ddc73daeb27fc3b5b009105185c44621c3c7cb

# Rationale
Single file: compiler/rustc_target/src/target_features.rs, `Target::abi_required_features`.
In 1.99.1 the fix's allow_toggle closures were replaced by ABI-required feature constraints. I removed `x87` from `required` for x86 (default hardfloat), x86 SSE2 and x86_64 hardfloat, and `fpregs` from `required` for ARM hard-float. Thus disabling x87/fpregs on hard-float targets is no longer rejected.
This re-expresses fix.diff hunks:
- `@@ -450,13 +467,28 @@ X86_FEATURES`: the "x87" entry whose allow_toggle returned Err("unsound on hard-float targets because it changes float ABI") unless soft-float (removing the FIXME "need to also forbid turning off `x87` on hardfloat targets").
- `@@ -168,6 +170,22 @@ ARM_FEATURES`: the "fpregs" entry with the same allow_toggle.
