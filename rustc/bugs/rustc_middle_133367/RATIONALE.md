# Adapted injection for Simplify array length mismatch error reporting

Fix: https://github.com/rust-lang/rust/commit/28970a2cb0885ba7922820d6fb0e14c7e166df9b

Re-injects the pre-fix behaviour: array length mismatches only get the special ArraySize error when both lengths are concrete usize values; otherwise the generic ConstMismatch error is returned (so `expected N, found M` plus expected/found array notes). The fix's FixedArraySize(u64) variant itself was not restored; ArraySize(Const) is kept, gated as before.

- compiler/rustc_type_ir/src/relate.rs, structurally_relate_tys (Array arm): re-expresses hunk `@@ -501,19 +501,10 @@` — restores `Err(err) => { sz_a.try_to_target_usize(cx) ... (Some(a), Some(b)) if a != b => Err(ArraySize(..)), _ => Err(err) }` in place of `Err(TypeError::ConstMismatch(_)) => Err(ArraySize(..))`.
- compiler/rustc_type_ir/src/inherent.rs, trait Const: re-adds `fn try_to_target_usize(self, interner: I) -> Option<u64>;` (hunk `@@ -257,8 +257,6 @@`).
- compiler/rustc_middle/src/ty/consts.rs, impl inherent::Const for Const: re-adds the delegating `try_to_target_usize` (hunk `@@ -151,10 +151,6 @@`).
