# Rationale

Fix: gh-78724 added `ENSURE_STRUCT_IS_READY` (RuntimeError when `s_codes` is NULL) to the Struct methods; before, they only had `assert(self->s_codes != NULL)`.

In v3.15.2 `Modules/_struct.c` the prepare_s ordering hunk is already different (s_size/s_len are set after codes alloc), and the macro is present. I reverted the macro use in the five methods the fix touched, restoring the pre-fix `assert(self->s_codes != NULL)`:
- `Struct_unpack_impl`, `Struct_unpack_from_impl`, `Struct_iter_unpack_impl`, `Struct_pack`, `Struct_pack_into` (reverse the fix's matching hunks).

The macro stays defined and in use for `__sizeof__`/`__repr__` (not part of the fix). `s_get_format` is now a member descriptor (AttributeError), so that hunk has no equivalent.

Result: on `Struct.__new__(Struct)` the methods dereference NULL `s_codes` (release build: no assert) -> crash instead of RuntimeError. `test_operations_on_half_initialized_Struct` fails (run crashes, taking later struct tests with it).
