Dumps str subclasses (with an overridden `__str__`, and a `str, Enum` mixin) through the C json encoder.
Clean: output uses the underlying string value (`"ascii"`, `"color"`).
Buggy: `PyUnicodeWriter_WriteStr` calls `str(obj)`, so output is `"StrSubclass"` / `"E.COLOR"`-style wrong text.
