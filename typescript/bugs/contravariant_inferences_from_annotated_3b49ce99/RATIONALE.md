# Rationale
One hunk, `tree/src/compiler/checker.ts`, `inferFromAnnotatedParametersAndReturn`. It matches the single hunk of fix.diff.
The fix wrapped the annotated parameter type in `addOptionality(..., isOptionalDeclaration(declaration))` before `inferTypes`.
I removed that, so the plain annotation type is the inference source again. Optional annotated parameters then lose their `| undefined`, which brings back the wrong contravariant inferences.

SUMMARY: 2/12 oracle cases failing (2 fix-added).
