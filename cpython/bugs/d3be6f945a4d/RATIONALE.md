# Rationale

Change (Lib/annotationlib.py, `_Stringifier.__make_new`): removed the line
`self.__stringifier_dict__.stringifiers.append(stringifier)`.

This reverses the fix hunk in `__make_new` that registers each derived stringifier
with the stringifier dict. (v3.15.2 already has the `__stringifier_dict__` slot and
plumbing, so only the registration is dropped.) Without it, stringifiers created by
operations (attribute, subscript, call, binary/unary ops) are never converted to
`ForwardRef` in `call_annotate_function`/the dict's `transmogrify`, so nested
expressions such as `some.module` are returned as raw `_Stringifier` objects
instead of `ForwardRef` (gh-125614).

Oracle: 10 failures in test_annotationlib, e.g. `TestStringFormat.test_getitem`
(`undef1[...]` is not an instance of ForwardRef) and the nonexistent-attribute
tests under FORWARDREF format.
