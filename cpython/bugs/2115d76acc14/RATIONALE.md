# Rationale

Change (Objects/typevarobject.c): reverts the `TypeAliasType(...)` constructor validation added by the fix.

- Removed `typealias_check_type_params()` and its call in `typealias_new_impl`; the constructor now just passes `typealias_convert_type_params(type_params)` (the pre-fix behaviour: store the tuple unchecked, empty tuple -> NULL). This reverses the fix's `typealias_new_impl` hunk and the new check function hunk.
- Removed `get_type_param_default()`, which only served that check (the "Expected a type param" error). It is now unused, so it is dropped to avoid an unused-static warning.
- `typealias_convert_type_params` and `_Py_make_typealias` are left alone: they already existed in the fixed form and the pre-fix equivalent is the same behaviour.

Failing oracle cases (5 failures): `test_type_params_order_with_defaults` (no TypeError for non-default following default, all subtests) and `test_expects_type_like` (no TypeError "Expected a type param" for non-type-param entries).
