# Adapted injection for Fix an ICE when using `become` in a default trait method

Fix: https://github.com/rust-lang/rust/commit/ac5734a779df315af218a1da8eb5856f3ce22a87

# Rationale
All changes in compiler/rustc_mir_build/src/check_tail_calls.rs (the builtin.rs hunk of fix.diff, a lint-list entry, was not applicable/needed).
- `check_tail_calls` and `TailCallCkVisitor`: restore `caller_ty: Ty` field (computed from `tcx.type_of(def)`) instead of `caller_def_id` (fix hunks `@@ -21,7 +22,6`, `@@ -30,7 +30,7`, `@@ -47,8 +47,8`); restore `DUMMY_SP` import and drop `CodegenFnAttrFlags` import.
- signature-mismatch report uses `self.caller_ty` again (hunk `@@ -148,11 +148,13`).
- `needs_location(ty)` restored: uses `Instance::expect_resolve` + `requires_caller_location` (only works for resolvable FnDefs; ICEs for default trait methods) instead of `caller_needs_location()` checking `codegen_fn_attrs(..).flags` TRACK_CALLER (hunks `@@ -173,7 +175,7` and `@@ -189,19 +191,11`). Needed `no_bound_vars().unwrap()` on substs for 1.99.1 API.
