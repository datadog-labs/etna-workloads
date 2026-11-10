# Rationale
One hunk changed: tree/src/compiler/transformers/es2018.ts, visitBinaryExpression.
Corresponds to fix.diff's es2018.ts hunk `visitBinaryExpression`: the fix replaced the plain
`node.left.transformFlags & ContainsObjectRestOrSpread` check with `containsObjectRestOrSpread(node.left)`,
which walks nested assignment patterns. Reverting to the flag-only check means nested object rest in an
assignment pattern (`{ x: { a, ...b } = foo } = c`) is not downleveled, so the emit is wrong.
(The other fix hunks were left intact; this alone makes the tests fail.)

Final check.sh: SUMMARY: 2/12 oracle cases failing (1 fix-added).
