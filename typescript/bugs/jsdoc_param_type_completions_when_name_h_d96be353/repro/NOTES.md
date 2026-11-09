Input is a JS file with `/** @param {Str} */` (type written, parameter name not yet), and we request completions inside the braces.
Clean: returns type completions (any, boolean, ...), since the cursor is in the type expression.
Injected: treats it as a param-name position and returns only `obj`.
