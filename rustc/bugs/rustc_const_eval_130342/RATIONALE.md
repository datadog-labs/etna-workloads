# Adapted injection for interpret: fix dealing with overflow during slice indexing

Fix: https://github.com/rust-lang/rust/commit/3b806d337c0cb83bde42a7d4898ff183f888c488

# Rationale
File: compiler/rustc_const_eval/src/interpret/projection.rs, fn `project_index` (Array stride arm).
Re-expresses fix hunk `@@ -229,7 +229,11 @@` in projection.rs: the fix replaced
`let offset = stride * index; // Size multiplication` with
`self.compute_size_in_bytes(stride, index).ok_or_else(|| err_ub!(PointerArithOverflow))?`.
I restored the unchecked `stride * index`, which panics (ICE) on overflow for huge raw slice lengths.
The helper `compute_size_in_bytes` and its other users (copy/write_bytes) are left intact.
