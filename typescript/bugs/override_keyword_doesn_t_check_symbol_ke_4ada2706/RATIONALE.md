# Rationale
One hunk in `tree/src/compiler/checker.ts`, `checkMemberForOverrideModifier`. It matches the fix hunk that changed the lookup from `memberName` to `member.escapedName`.
Before the fix, the code looked up props via `escapeLeadingUnderscores(symbolName(member))`. I restored that. For symbol-keyed (late-bound) members the `symbolName` round trip does not give the real escaped name, so the lookup fails and `override` is not checked.
The signature already takes `member: Symbol`, since today's code also uses it for the dynamic-name check. I kept it rather than reverting the other fix hunks.
Final check.sh: SUMMARY: 1/6 oracle cases failing (1 fix-added).
