# Re-introduced bug: napi_define_properties accessors not ECMAScript-compliant

**Bug.** `napi_define_properties` defined accessor properties through V8's legacy
native-accessor API (`SetAccessor`) instead of `DefineProperty` with a
`v8::PropertyDescriptor`. The result is a native *data-like* property:
`Object.getOwnPropertyDescriptor` shows `value` rather than `get`/`set`, and a
getter-only property gives the read-only error instead of the
"which has only a getter" TypeError.

**Change (src/js_native_api_v8.cc), one hunk in the accessor branch.**
Corresponds to the fix's first hunk (the `p->getter || p->setter` branch). The
`v8::PropertyDescriptor descriptor(local_getter, local_setter)` /
`DefineProperty` code is replaced by the pre-fix style: getter/setter functions are
packed into an array used as accessor data, and `SetNativeDataProperty` (the
current V8 name for the removed `Object::SetAccessor`) is called with
`V8PropertyAttributesFromDescriptor(p)`. That helper was kept, and it already
omits ReadOnly for accessors. To make this compile on today's code, I added two
small trampolines (`AccessorGetterInvoke`/`AccessorSetterInvoke`) that replace the
old `GetterCallbackWrapper`/`SetterCallbackWrapper`, which no longer exist. The
method and data-property branches were left unchanged. The fix's hunks for those
branches only moved them to `PropertyDescriptor`, which the release already
does and the old behaviour there was not observable by the oracle.

**Failing test.** `js-native-api/test_properties/test`, with
`AssertionError: The expression evaluated to a falsy value:
assert.ok(readwriteAccessor1Descriptor.get != null)` (test.js:49).
Failure was stable across repeated runs.
