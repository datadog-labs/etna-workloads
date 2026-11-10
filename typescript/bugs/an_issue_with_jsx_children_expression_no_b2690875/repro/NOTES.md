Input: JSX elements whose component takes a discriminated-union props type, with a function child `{(value) => {}}`.
Clean: the child is contextually typed via the attributes (discriminated by `renderNumber`), so no errors.
Injected: contextual type is taken from the tagName instead, so `value` is implicitly any: TS7006 errors on both lines.
