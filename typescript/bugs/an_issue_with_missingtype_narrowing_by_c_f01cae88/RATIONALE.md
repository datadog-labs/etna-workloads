# Rationale
One hunk in `tree/src/compiler/checker.ts` (default-clause branch of `narrowTypeBySwitchOnDiscriminant`), corresponding to the single hunk of fix.diff.

The fix added `t.flags & TypeFlags.Undefined ? undefinedType : ...` so a `missingType` in the type is matched by `case undefined` in the default clause. Today's code has since gained a comparable callback `(t1, t2) => isUnitType(t1) && areTypesComparable(t1, t2)` that also makes missing and undefined match, so removing only the undefined special-case changes nothing. To bring the bug back I reverted the line to its pre-fix form: `contains(switchTypes, getRegularTypeOfLiteralType(extractUnitType(t)))`. That means the default type is again filtered by identity, so `missingType` is not removed by `case undefined`, and the `never` argument in `assertUnreachable(optionalProp)` fails.

Final check.sh: SUMMARY: 6/24 oracle cases failing (6 fix-added).
