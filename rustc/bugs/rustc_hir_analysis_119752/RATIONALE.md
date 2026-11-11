# Adapted injection for Avoid ICE: Check diagnostic is error before downgrading

Fix: https://github.com/rust-lang/rust/commit/b1688b48d2841a1421cb7ed0afd32ce0c3eeb20a

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, fn `maybe_suggest_impl_trait` (the code formerly in astconv/lint.rs).

Re-expresses the fix hunk `@@ -148,8 +148,10 @@` in astconv/lint.rs:
```
 if !is_object_safe {
     diag.note(...not object safe...);
-    if diag.is_error() {
-        diag.downgrade_to_delayed_bug();
-    }
```
(fix added the `is_error()` guard). In 1.99.1 the not-dyn-compatible branch for function params is `if !is_dyn_compatible { diag.note(...) }`. I added an unconditional `diag.downgrade_to_delayed_bug();` after the note, i.e. the pre-fix behaviour with no `is_error()` check. The other fix hunk (`@@ -122,7 +122,7 @@`, `else if diag.is_error()`) has no counterpart left in 1.99.1.
Effect: in edition 2021 the E0782 error gets downgraded, so `avoid-ice-on-warning-2.rs#new` output changes and fails.
