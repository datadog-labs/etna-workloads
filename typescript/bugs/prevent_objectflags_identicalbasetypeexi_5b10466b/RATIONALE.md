All hunks are in tree/src/compiler/checker.ts.
- 3 hunks in removeConstrainedTypeVariables: drop the `type.flags & TypeFlags.Intersection &&` guard before `getObjectFlags(type) & ObjectFlags.IsConstrainedTypeVariable` — the same three hunks as fix.diff. A TypeReference with IdenticalBaseTypeExists (same bit, 1<<26) is then mistaken for a constrained type variable.
- 1 supporting hunk in addTypeToUnion (same guard removed): in today's code this guard was already present there, so removing only the fix's 3 hunks changed nothing; without it the confused flag never reaches removeConstrainedTypeVariables. Reintroduces the confusion at its source.
Result: SUMMARY: 6/6 oracle cases failing (6 fix-added).
