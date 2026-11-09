Input a.js defines a JSDoc `@callback C` with `@this {{a: string, b: number}}` plus two `@param`s, and assigns a function to a `@type {C}` const.
Clean: no errors (the @this tag is parsed as a child of the callback, so C has `this` type and 2 params).
Injected: reports TS2322 (target signature "expects 2 or more, got 0") and TS2683 ('this' implicitly any).
