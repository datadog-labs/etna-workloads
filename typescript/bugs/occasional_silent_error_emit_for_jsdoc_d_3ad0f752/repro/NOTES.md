Input: a JS file (checkJs/strict) with JSDoc `@param {number} [p]` and `[r=101]` optional parameters, emitted with --declaration.
Clean emits `p?: number, r?: number`; injected emits `p?: number | undefined, r?: number | undefined`
(the optional-JSDoc-parameter check in the type serializer wrongly ignores the JSDoc bracket syntax).
