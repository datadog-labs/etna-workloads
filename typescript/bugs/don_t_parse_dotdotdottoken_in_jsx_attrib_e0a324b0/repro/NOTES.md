Input: a .tsx file with a JSX attribute whose value starts with a spread: `<div a={...a} />`.
Clean: `...` is not parsed in an attribute value expression, so tsc reports a syntax error diagnostic and emits the corresponding JS.
Injected: the `...` is parsed as a spread token in the attribute value, so the diagnostics and emitted JS differ.
