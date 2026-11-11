# Adapted injection for Validate nested static items

Fix: https://github.com/rust-lang/rust/commit/8c9cba2be7c6c61ef91d722d27a55abb5eef371c

# Rationale
File: compiler/rustc_const_eval/src/interpret/validity.rs, fn check_safe_pointer (GlobalAlloc::Static arm, ~line 762-783).
Re-expresses fix hunk `@@ -471,7 +475,11 @@`: `skip_recursive_check = !nested;` reverted to `skip_recursive_check = true;`
(nested statics are no longer recursed into during Static/Promoted validation). The now-unused `nested` binding was dropped (`DefKind::Static { .. }`).
The other fix hunks (moving the def_kind lookup, the GlobalAlloc::Static mutability for nested) are already different in 1.99.1 and were not needed.
