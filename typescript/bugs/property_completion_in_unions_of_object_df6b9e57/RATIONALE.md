# Rationale
Hunk: tree/src/compiler/types.ts, TypeFlags.Primitive.
The fix added `TemplateLiteral` to `Primitive`. In today's code `Primitive` is built from `StringLike`, which already includes `TemplateLiteral`. To bring the bug back, `StringLike` is replaced in `Primitive` with `String | StringLiteral | StringMapping`, which leaves out `TemplateLiteral`. Template literal types are then no longer treated as primitive, so completions for unions of object and template literal types offer string members.

Final check.sh: SUMMARY: 1/1 oracle cases failing (1 fix-added).
