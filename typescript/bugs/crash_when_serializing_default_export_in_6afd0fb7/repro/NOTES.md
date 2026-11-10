Input: a nodenext project where `index.ts` assigns `import * as ns` of a package (`export =` of `typeof import("./lib/index.js")`, whose `export default` object type is involved) to an incompatible interface type.
Clean: tsc reports the normal assignability error (TS2322) while serializing the type in the diagnostic.
Injected: the `Debug.assert(isExpressionNode(node))` in `isUndefinedIdentifierExpression` fails, so tsc crashes with a Debug Failure.
