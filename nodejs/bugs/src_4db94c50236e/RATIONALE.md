# Re-introduced bug: wrong stride for dynamic import attributes

Dynamic-import callbacks receive the import attributes as a flat array of
[key, value] pairs (multiple of 2), but the container builder was told to
iterate with a stride of 3 (the static-link layout of key, value, location).
The fix passes `elements_per_attribute` = 2 for dynamic import.

## Change
`src/module_wrap.cc`, `ImportModuleDynamically`: the call
`createImportAttributesContainer(realm, isolate, import_attributes, 2)` became `..., 3)`.
This corresponds to the fix's hunk in `ImportModuleDynamically`. The current code already has
the `elements_per_attribute` parameter and the CHECK from the fix, so the old behaviour
(stride 3 for dynamic import) is restored by passing 3. With today's CHECK, the bad
stride aborts rather than silently misreading.

## Failures
`es-module/test-esm-import-attributes-errors` fails ("not ok") because
`import(url, { with: { type: 'json', other: 'unsupported' } })` hits
`CHECK_EQ(raw_attributes->Length() % elements_per_attribute, 0)` (4 % 3 != 0) and the
process aborts instead of rejecting with ERR_IMPORT_ATTRIBUTE_TYPE_INCOMPATIBLE.
