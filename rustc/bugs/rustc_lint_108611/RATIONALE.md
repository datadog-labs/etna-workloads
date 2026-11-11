# Adapted injection for lint/ctypes: ext. abi fn-ptr in internal abi fn

Fix: https://github.com/rust-lang/rust/commit/e3f90bca50d4fddb52fae2ba5f7b5b19e12566e8

# Rationale
File: compiler/rustc_lint/src/types/improper_ctypes.rs (1.99.1 moved the logic here from types.rs).

Fix hunks (`@@ -1411,16 +1458,14 @@ ... ImproperCTypesDeclarations` and `@@ -1444,9 +1489,7 @@ ... ImproperCTypesDefinitions`) replaced `if !vis.is_internal_abi(abi) { check_foreign_fn }` with `check_maybe_foreign_fn`, which for internal ABIs walks the signature for external-ABI fn-ptrs (`find_fn_ptr_ty_with_external_abi`, hunks 1-3).
In 1.99.1 that is `check_fn_for_external_abi_fnptr`, called in the `else` branch (internal ABI) of:
- `ImproperCTypesLint::check_fn` (definitions): removed the else branch, so internal-ABI fns are skipped again.
- `ImproperCTypesLint::check_foreign_item` (Fn declarations): removed the else branch likewise.
The helper is left in place (still used by check_item etc. paths? it is now unused for fns; only a dead-code warning at worst).
