# Rationale (gh-89850)

v3.15.2 already has the fix's default C `persistent_id()`/`persistent_load()`
methods, though built on top of `persistent_id_attr`/`persistent_load_attr`
instance-attribute shims. I removed the defaults, as before the fix, in
`Modules/_pickle.c`:

- Removed the `persistent_id` C function and its `Pickler_methods` entry (fix hunks adding both).
- Removed `_PICKLE_UNPICKLER_PERSISTENT_LOAD_METHODDEF` from `Unpickler_methods` (fix hunk adding it). The impl stays as dead code.
- `dump()`: `PyObject_GetAttr(persistent_id)` + default-method detection is replaced by `PyObject_GetOptionalAttr`, so a missing attribute means "no persistent_id". This is the pre-fix state where `pers_func` could be NULL.
- `load()`: likewise `PyObject_GetOptionalAttr(persistent_load)`.
- `load_persid`/`load_binpersid`: restored the `persistent_load == NULL` -> UnpicklingError check (fix hunks that removed the `if (self->pers_func)` / else branches).

Effect: the C Pickler/Unpickler have no `persistent_id`/`persistent_load`
attribute unless a subclass or instance defines one, so `super().persistent_id(obj)`
and `super().persistent_load(pid)` in a subclass fail (AttributeError; formerly recursion).

Failing oracle cases: CIdPersPicklerTests.test_pickler_super,
test_unpickler_super (the fix's tests), plus the `*_super_instance_attribute`
and `*_instance_attribute` variants, which read the default method.
The `test_unpickle_module_race` failures are read-only-filesystem environment errors and unrelated.
