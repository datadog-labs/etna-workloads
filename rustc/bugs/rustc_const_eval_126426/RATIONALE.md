# Adapted injection for const validation: fix ICE on dangling ZST reference

Fix: https://github.com/rust-lang/rust/commit/a6907100de23e51ba979ead543fcd5975d62d248

# Rationale
File: compiler/rustc_const_eval/src/interpret/validity.rs, fn `visit_ref`-style check (`check_safe_pointer`), CTFE branch where `try_get_global_alloc(alloc_id)` is None.
Fix hunk `@@ -493,9 +491,17 @@` added "Dangling and Mutability check": if the alloc is Dead, `throw_validation_failure!(DanglingPtrUseAfterFree)` (for zero-sized dangling refs). In 1.99.1 that logic lives in the let-else on `try_get_global_alloc`; I replaced the `throw_validation_failure!(... use-after-free)` with `return interp_ok(())`, so dangling (ZST) refs are silently accepted by validation, as before the fix (leading to the later ICE/other error).
