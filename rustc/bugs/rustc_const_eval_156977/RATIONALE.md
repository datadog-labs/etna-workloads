# Adapted injection for interpret: properly check for inhabitedness of nested references

Fix: https://github.com/rust-lang/rust/commit/88ff4b02135dc96bc83df3beb81c1f2c2480d9ea

Only compiler/rustc_const_eval/src/interpret/validity.rs changed (visit_ref/check_safe_pointer and the final assert in visit_value):
- Reference check: `@@ -686,11 +687,11 @@` `-if place.layout.is_uninhabited()` / `+if !place.layout.ty.is_opsem_inhabited(...)` reversed to the layout-only check (nested refs to uninhabited types are no longer detected); message backticks around `{ty}` removed as in the same hunk.
- Final assert: `@@ -1524,8 +1525,9 @@` `!val.layout.is_uninhabited()` restored in place of the is_opsem_inhabited assertion.
The new query/helper (other hunks) was left in place (unused); the fix's monomorphic check and layout invariant are not needed to reproduce the bug.
