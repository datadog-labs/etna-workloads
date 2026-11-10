# Rationale

**Bug:** `napi_get_property_names` is documented to return an array of strings, but index keys came back as numbers (e.g. `5` instead of `'5'`), because V8 was not told to convert keys to strings.

**Hunk:** `src/js_native_api_v8.cc`, in `napi_get_property_names`. It corresponds to the fix's hunk that added `v8::KeyConversionMode::kConvertToString`. The function now delegates to `napi_get_all_property_names`, so the equivalent change is to pass `napi_key_keep_numbers` instead of `napi_key_numbers_to_strings`. This maps to `KeyConversionMode::kKeepNumbers`, which is V8's pre-fix default, so integer indices stay numbers.

**Failing test:** `js-native-api/test_object/test` fails with `AssertionError: Expected values to be strictly deep-equal: + 5 - '5'`.
