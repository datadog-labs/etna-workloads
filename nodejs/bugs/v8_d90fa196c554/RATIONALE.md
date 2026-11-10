# Re-introduced bug: v8 native serdes constructors (d90fa196c554)

**Bug.** `v8.Serializer`/`v8.Deserializer` native constructors did not check `IsConstructCall()`, so calling them without `new` was only guarded by a JS wrapper subclass (`class Serializer extends _Serializer {}`). The error was a plain TypeError from the class semantics, with no `ERR_CONSTRUCT_CALL_REQUIRED` code. The native functions also lacked `ReadOnlyPrototype()` and `Deserializer` lacked `SetLength(1)`.

**Hunks.**
- `lib/v8.js` import: corresponds to the fix's import hunk. It imports `_Serializer`/`_Deserializer` again.
- `lib/v8.js` wrapper classes: corresponds to the fix's removal of the wrapper classes. They are restored.
- `src/node_serdes.cc` `SerializerContext::New` and `DeserializerContext::New`: corresponds to the fix's added `IsConstructCall` checks. They are removed.
- `src/node_serdes.cc` `Initialize`: corresponds to the fix's added `ReadOnlyPrototype()` calls and `des->SetLength(1)`. They are removed.

**Failing test.** `parallel/test-v8-serdes` fails (stable across 2 runs). The assertion on `v8.Serializer()` expects `code: 'ERR_CONSTRUCT_CALL_REQUIRED'`, but the actual error is a plain `TypeError: Class constructor Serializer cannot be invoked without 'new'` with no code.
