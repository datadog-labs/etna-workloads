A checkJs file declares two `/** @type {unique symbol} */` consts, and `let z` annotated `/** @type {typeof x} */`, then compares `z == y`.
Clean: z keeps the unique symbol type of x, so tsc reports the "no overlap" comparison error (TS2367).
Injected: z is widened to `symbol` (JSDoc type is ignored in the check), so no error is reported.
