# Adapted injection for Fixed the `private-dependency` bug: If the directly dependent crate is loaded last and is not configured with `--extern`, it may be incorrectly set to `private-dependency`

Fix: https://github.com/rust-lang/rust/commit/92325a95b3830e693e11c3575254d133f6dd7c5b

# Rationale
File: compiler/rustc_metadata/src/creader.rs, `resolve_crate` (the `(LoadResult::Previous(cnum), None)` arm).

Re-expresses fix hunk `@@ -599,14 +601,17 @@`: the fix computes `private_dep = self.is_private_dep(..)` for a previously
loaded crate and unconditionally calls `update_and_private_dep(private_dep)`. The old code did
`if let Some(private_dep) = private_dep { data.update_and_private_dep(private_dep); }`, so a directly
dependent crate (private_dep = None) that was first registered as private via another crate is never
made public. I restored that conditional update (and removed the comment/early computation).
The other fix hunks (extracting `is_private_dep`) are a refactor; 1.99.1 already has the helper, left as is.
