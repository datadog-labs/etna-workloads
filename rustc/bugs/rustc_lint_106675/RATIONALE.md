# Adapted injection for Mark ZST as FFI-safe if all its fields are PhantomData

Fix: https://github.com/rust-lang/rust/commit/797f2479974bfe0d759f4a2bd51dfef95b8d75cf

# Rationale
File compiler/rustc_lint/src/types/improper_ctypes.rs, fn visit_variant_fields (successor of check_variant_for_ffi).
Fix hunk `@@ -878,39 +878,39 @@` made transparent all-ZST structs fall through to the all_phantom check
(`if all_phantom { FfiPhantom(ty) } else { transparent_safety.unwrap_or(FfiSafe) }`), so all-PhantomData transparent types are FFI-safe.
Re-injected old behaviour: in 1.99.1 the final tail checks `transparent_with_all_zst_fields` before `all_phantom`, so a transparent struct of only PhantomData is reported as "contains only zero-sized fields" (the pre-fix unconditional FfiUnsafe).
