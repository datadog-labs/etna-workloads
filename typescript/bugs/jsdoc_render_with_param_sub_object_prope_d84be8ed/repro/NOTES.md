Input: a JS file with a JSDoc `@param` having two levels of sub-properties (`o.a`, `o.a.b`); a language-service quick info request on the function.
Clean: quick info tags include the nested `o.a.b` tag (recursively collected).
Injected: only first-level property tags (`o.a`) are emitted; the deeper `o.a.b` tag is missing.
