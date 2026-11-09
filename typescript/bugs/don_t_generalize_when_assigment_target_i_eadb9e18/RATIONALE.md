# Rationale
One hunk in `tree/src/compiler/checker.ts` (`reportRelationError`): removed the `!(target.flags & TypeFlags.Never)` guard and its comment, matching the single hunk of fix.diff. Literal sources are again generalized (e.g. `"a"` -> `string`) in errors when the target is `never`, as in `assertNever`.

SUMMARY: 24/156 oracle cases failing (1 fix-added).
