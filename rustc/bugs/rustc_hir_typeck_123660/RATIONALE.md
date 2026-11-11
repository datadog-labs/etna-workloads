# Adapted injection for Make the computation of coroutine_captures_by_ref_ty more sophisticated

Fix: https://github.com/rust-lang/rust/commit/599d456a7532aa5de020b42fd1d9d936fa647573

# Rationale
File: compiler/rustc_hir_typeck/src/upvar.rs, closure-kind analysis (coroutine_captures_by_ref_ty computation).
Re-expresses hunk `@@ -367,37 +367,48 @@` of fix.diff: the fix introduced `needs_ref = should_reborrow_from_env_of_parent_coroutine_closure(parent_capture, child_capture)` and used `if needs_ref { Some(closure_env_region) } else { child_capture.region }`. The buggy parent always used `Some(closure_env_region)`. In 1.99.1 I set `needs_ref = true` unconditionally, so every by-ref child capture is reborrowed from the closure env.
The second hunk (adding the helper fn) is left in place; it is now unused (dead code), equivalent to the parent not having it.
