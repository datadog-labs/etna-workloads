# Rationale
One hunk in `src/services/codefixes/fixAddMissingMember.ts` (tryGetValueFromType, enum branch): the `symbolToExpression` call's flags argument changed from `NodeBuilderFlags.UseFullyQualifiedType` back to `undefined`. This matches the single hunk of fix.diff, so the enum name loses its namespace qualification (`E.E1` instead of `Foo.Bar.E.E1`).

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
