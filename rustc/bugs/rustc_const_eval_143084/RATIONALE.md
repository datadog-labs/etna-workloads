# Adapted injection for const-eval: error when initializing a static writes to that static

Fix: https://github.com/rust-lang/rust/commit/ed4f01ed2e033098f6c5e10a4a0cc740dc04f958

# Rationale
File: compiler/rustc_const_eval/src/interpret/memory.rs
1. `get_ptr_alloc_mut`: removed `M::before_alloc_access(tcx, machine, alloc_id)?;` before `M::before_memory_write` — re-expresses fix hunk `@@ -821,6 +821,9 @@ ... get_ptr_alloc_mut` (added the access hook for writes). Without it, writes to a static's own allocation during its initialization are not rejected.
2. `mem_copy_repeatedly`: removed `M::before_alloc_access(tcx, machine, dest_alloc_id)?;` for the destination — re-expresses fix hunk `@@ -1438,16 +1446,18 @@` ("...and access hooks.").
Other fix hunks (rename, message text) left as-is; the bug is the missing write hook.
