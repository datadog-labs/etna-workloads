input.js is a checked JS file with a function using a destructured binding parameter and `arguments`, plus a JSDoc `@param {{a: string}} argument` tag.
Clean: no diagnostics (exit 0), since the binding parameter's JSDoc tag is excluded from the check.
Injected: reports TS8029 "JSDoc '@param' tag has name 'argument' ... would match 'arguments'" (exit 2).
