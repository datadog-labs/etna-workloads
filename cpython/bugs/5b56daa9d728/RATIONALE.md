# Rationale

All changes are in `Lib/typing.py`.

1. `_eval_type`: `return _rebuild_generic_alias(t, ev_args)` -> `return GenericAlias(t.__origin__, ev_args)`.
   Reverses the fix hunk that replaced `GenericAlias(t.__origin__, ev_args)` with the helper. The plain constructor drops
   `GenericAlias` subclasses (and `__unpacked__`).
2. `_strip_annotations`: `_rebuild_generic_alias(t, stripped_args)` -> `GenericAlias(t.__origin__, stripped_args)`.
   Reverses the matching hunk, so stripping `Annotated` also loses the subclass.
3. Removed the `_rebuild_generic_alias` helper, which the fix added and which is now unused.

The earlier pre-fix inline rebuild in `_eval_type` is already absent in v3.15.2, so only the two call sites matter.

## Oracle failure
`test_typing.GetTypeHintsTests.test_get_type_hints_preserve_generic_alias_subclasses` fails:
`get_type_hints(func)['x']` is a plain `types.GenericAlias`, not `MyAlias`.
