# Adapted injection for Use the correct bound vars in return type suggestion.

Fix: https://github.com/rust-lang/rust/commit/1e9b58bdf8dcb88ee21fbb8b0d2e86cba2b4cbb6

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs, fn suggest_missing_return_type.

1. Re-expresses fix hunk `@@ -737,11 +734,11 @@` (`-let bound_vars = self.tcx.late_bound_vars(fn_id);` / `+...late_bound_vars(hir_ty.hir_id.owner.into())`): bound vars are now taken from the wrong HirId (`hir_ty.hir_id`, the return type node, instead of the fn owner), so the late-bound vars don't match the lowered type (`&'a str` / async opaque) -> ICE in Binder/erase.
2. Re-expresses the old control flow in fix hunk `@@ -705,28 +706,24 @@`: before the fix the Future-opaque `if let` was a plain `if` with no `else`, so the common lowered-type/bound-vars code was also reached for async fns. In 1.99.1 that code sits in an `else`; changing `} else {` to `}` + bare block restores the fall-through, so the bound-vars code is reached for the async return type.
